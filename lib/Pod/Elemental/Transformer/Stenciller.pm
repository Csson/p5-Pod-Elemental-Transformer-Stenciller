use Stenciller::Standard;
use strict;
use warnings;

# VERSION:
# PODCLASSNAME
# ABSTRACT: Injects content from textfiles transformed with Stenciller
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
        documentation => 'Path to directory where the stencil files are.'
    );
    has settings => (
        isa => HashRef,
        traits => ['Hash'],
        default => sub { {} },
        documentation_default => '{ }',
        documentation_order => 0,
        documentation => 'If a plugin takes more attributes..',
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
        documentation_order => 0,
        init_arg => undef,
        traits => ['Hash'],
        handles => {
            get_plugin => 'get',
            set_plugin => 'set',
        },
    );
    has stencillers => (
        is => 'ro',
        isa => HashRef,
        traits => ['Hash'],
        handles => {
            get_stenciller_for_filename => 'get',
            set_stenciller_for_filename => 'set',
        },
        documentation_order => 0,
    );
    has loader => (
        is => 'ro',
        isa => Object,
        init_arg => undef,
        default => sub { Module::Loader->new },
        documentation_order => 0,
    );
    around BUILDARGS($next: $class, @args) {
        my $args = ref $args[0] eq 'HASH' ? $args[0] : { @args };

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
            chomp $filename;
            my $node_settings = defined $possible_hash && $possible_hash =~ m{\{.*\}} ? $self->eval_to_hashref($possible_hash, $filename) : {};

            my $stenciller = $self->get_stenciller_for_filename($filename);

            if(!Stenciller->check($stenciller)) {
                $stenciller = Stenciller::->new(filepath => path($self->directory)->child($filename));
                carp sprintf '! no stencils in %s/%s - skipping', $self->directory, $filename and return '' if !$stenciller->has_stencils;

                $self->set_stenciller_for_filename($filename => $stenciller);
            }

            my $transformed_content = $stenciller->transform(plugin_name => $plugin_name,
                                                             constructor_args => $self->settings,
                                                             transform_args => { %$node_settings, require_in_extra => { key => 'to_pod', value => 1, default => 1 } },
                                                            );
            $transformed_content =~ s{[\v\h]+$}{};
            $node->content($transformed_content);

        }
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

=pod

=head1 SYNOPSIS

    # in weaver.ini
    [-Transformer / Stenciller]
    transformer = Stenciller
    directory = path/to/stencildir

=head1 DESCRIPTION

This transformer uses a special command in pod files to inject content from elsewhere via a L<Stenciller> transformer plugin.

=head2 Example

1. Start with the C<weaver.ini> from the L</"synopsis">.

2. Add a textfile, in C<path/to/stencildir/file-with-stencils.stencil>:

    == stencil { } ==

    Header text

    --input--

        Input text

    --end input--

    Between text

    --output--

        Output text

    --end output--

    Footer text

3. Add a Perl module:

    package A::Test::Module;

    1;

    __END__

    =pod

    =head1 NAME

    =head1 DESCRIPTION

    :stenciller ToUnparsedText file-with-stencils.stencil

The last line in the Perl module will cause the textfile to be parsed with L<Stenciller>, and then transformed using the L<Stenciller::Plugin::ToUnparsedText> plugin.

It would be rendered like this (between I<begin> and I<end>):

I<begin>

Header text

    Input text

Between text

    Output text

Footer text

I<end>

=cut

=head1 SEE ALSO

=for :list
* L<Stenciller>
* L<Stenciller::Plugin::ToUnparsedText>
* L<Pod::Weaver>
