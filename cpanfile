requires 'perl', '5.014000';

requires 'Syntax::Feature::Qs';
requires 'Moose', '2.0000';
requires 'Moops', '0.034';
requires 'Pod::Elemental::Transformer';
requires 'Stenciller', '0.1202';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::Differences';
    requires 'Pod::Elemental';
    requires 'Pod::Elemental::Transformer::Pod5';
};
