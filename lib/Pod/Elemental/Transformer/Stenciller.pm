use Stenciller::Standard;

# VERSION
# PODCLASSNAME
# ABSTRACT: Injects text parsed with Stenciller::Plugin::ToUnparsed::Text
use Stenciller;

class Pod::Elemental::Transformer::Stenciller
using Moose
 with Pod::Elemental::Transformer, Stenciller::Utils :ro {

    use Carp 'croak';
    use Module::Loader;

    has directory => (
        is => 'ro',
        isa => Dir,
        coerce => 1,
        required => 1,
    );
    has settings => (
        isa => HashRef,
        traits => ['Hash'],
        default => sub { {} },
        documentation_default => '{ }',
        handles => {
            get_setting => 'get',
            set_setting => 'set',
            all_settings => 'elements',
        },
    );
    has plugins => (
        isa => HashRef,
        default => sub { {} },
        documentation_default => '{ }',
        init_arg => undef,
        traits => ['Hash'],
        handles => {
            get_plugin => 'get',
            set_plugin => 'set',
        },
    );
    has loader => (
        is => 'ro',
        isa => Object,
        init_arg => undef,
        default => sub { Module::Loader->new },
    );
    around BUILDARGS($next: $class, @args) {
        my $args = { @args };

        $class->$next(
            directory => delete $args->{'directory'},
            settings  => $args
        );
    }

    method transform_node($main_node) {

        NODE:
        foreach my $node (@{ $main_node->children }) {
            my $content = $node->content;
            my $start = substr($content, 0, 11, '');
            next NODE if $start ne ':stenciller';

            $content =~ s{^\h+}{};             # remove leading whitespace
            next if $content !~ m{([^\h\v]+)}; # the next sequence of non-space is the wanted plugin name

            my $wanted_plugin = $1;
            my $plugin_name = $self->ensure_plugin($wanted_plugin);

            (undef, my($filename, $possible_hash)) = split /\h+/ => $content, 3;
            my $node_settings = $self->eval_to_hashref($possible_hash, $filename);

            my $stenciller = Stenciller->new(filepath => path($self->directory)->child($filename));
            carp sprintf '! no stencils in %s/%s - skipping', $self->directory, $filename and return '' if !$stenciller->has_stencils;

            $node->content($self->make_output($stenciller, $plugin_name, $node_settings));
        }
    }

    method make_output($stenciller, $plugin_name, $node_settings) {
        return $stenciller->transform($plugin_name);
    }

    method ensure_plugin(Str $plugin_name) {
        return $self->get_plugin($plugin_name) if $self->get_plugin($plugin_name);

        my $plugin_class = sprintf 'Stenciller::Plugin::%s', $plugin_name;
        $self->loader->load($plugin_class);

        if(!$plugin_class->does('Stenciller::Transformer')) {
            croak("[$plugin_name] doesn't do the Stenciller::Transformer role. Quitting.");
        }
        $self->set_plugin($plugin_name => $plugin_name);
        return $plugin_name;
    }
}

1;
