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
        handles => {
            get_setting => 'get',
            set_setting => 'set',
            all_settings => 'elements',
        },
        documentation_default => '{ }',
        documentation_order => 0,
        documentation => 'If a plugin takes more attributes..',
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
        documentation_order => 0,
    );
    has stencillers => (
        is => 'ro',
        isa => HashRef,
        traits => ['Hash'],
        init_arg => undef,
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

:splint classname Pod::Elemental::Transformer::Stenciller

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

    == stencil { to_pod => 1 } ==

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

The last line in the Perl module will result in the following:

=for :list
* The textfile is parsed with L<Stenciller>
* The textfile is then transformed using the L<Stenciller::Plugin::ToUnparsedText> plugin.
* The ':stenciller ...' line in the pod is replaced with the transformed content.

=head2 Pod hash

It is possible to filter stencils by index with an optional hash in the pod:

    :stenciller ToUnparsedText 1-test.stencil { stencils => [0, 2..4] }

This will only include the stencils with index 0, 2, 3 and 4 from C<file-with-stencils.stencil>.

=head2 Stencil hash

This module checks for the C<to_pod> key in the stencil hash. If it has a true value (or doesn't exist) it is included in the transformation.

However, any stencil excluded by the L</"Pod hash"> is already disregarded. It is probably least confusing to choose B<one> of these places to do all filtering.

=head1 ATTRIBUTES

:splint attributes

=head1 SEE ALSO

=for :list
* L<Stenciller>
* L<Stenciller::Plugin::ToUnparsedText>
* L<Pod::Weaver>

=cut
