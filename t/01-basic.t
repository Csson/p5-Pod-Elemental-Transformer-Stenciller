use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Differences;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Pod::Elemental;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Transformer::Stenciller;

ok 1;

my $pod5 = Pod::Elemental::Transformer::Pod5->new;
my $stenciller = Pod::Elemental::Transformer::Stenciller->new(directory => 't/corpus/source');

my $doc = Pod::Elemental->read_file('t/corpus/lib/Test/For/StencillerFromUnparsedText.pm');
$pod5->transform_node($doc);
$stenciller->transform_node($doc);
eq_or_diff $doc->as_pod_string, result(), 'correct';




done_testing;

sub result {
	return q{=pod

=cut
package Test::For::StencillerFromUnparsedText;

1;

__END__

=pod


=head1 NAME

=head1 DESCRIPTION



Intro text
goes  here

thing

here

    other thing

in between
is three lines
in a row

    expecting this

A text after output

=cut
};
}