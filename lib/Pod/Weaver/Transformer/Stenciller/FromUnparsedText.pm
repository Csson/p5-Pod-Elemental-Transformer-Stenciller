use Stenciller::Standard;

# VERSION
# PODCLASSNAME
# ABSTRACT: Injects text parsed with Stenciller::Plugin::ToUnparsed::Text

class Pod::Elemental::Transformer::Stenciller::FromUnparsedText
using Moose
 with Pod::Elemental::Transformer {

    has directory => (
        is => 'ro',
        isa => File,
        required => 1,
    );
    has filepattern => (
        is => 'rw',
        isa => RegexpRef,
        default => sub { qr/^\w-\d+\.stencil$/ },
    );
    
    

    method transform_node {

    }

}







1;


__END__

=pod

:splint classname Pod::Elemental::Transformer::Stenciller::FromUnparsedText

=head1 SYNOPSIS

    use Pod::Weaver::Plugin::Stenciller::FromUnparsedText;

=head1 DESCRIPTION

Pod::Weaver::Plugin::Stenciller::FromUnparsedText is ...

=head1 ATTRIBUTES

:splint attributes

=head1 SEE ALSO

=cut
