# NAME

Pod::Elemental::Transformer::Stenciller - Injects content from textfiles transformed with Stenciller

# VERSION

Version 0.0001, released 2015-02-07.

# SYNOPSIS

    # in weaver.ini
    [-Transformer / Stenciller]
    transformer = Stenciller
    directory = path/to/stencildir

# DESCRIPTION

This transformer uses a special command in pod files to inject content from elsewhere via a [Stenciller](https://metacpan.org/pod/Stenciller) transformer plugin.

## Example

1\. Start with the `weaver.ini` from the ["synopsis"](#synopsis).

2\. Add a textfile, in `path/to/stencildir/file-with-stencils.stencil`:

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

3\. Add a Perl module:

    package A::Test::Module;

    1;

    __END__

    =pod

    =head1 NAME

    =head1 DESCRIPTION

    :stenciller ToUnparsedText file-with-stencils.stencil

The last line in the Perl module will cause the textfile to be parsed with [Stenciller](https://metacpan.org/pod/Stenciller), and then transformed using the [Stenciller::Plugin::ToUnparsedText](https://metacpan.org/pod/Stenciller::Plugin::ToUnparsedText) plugin.

It would be rendered like this (between _begin_ and _end_):

_begin_

Header text

    Input text

Between text

    Output text

Footer text

_end_

# SEE ALSO

- [Stenciller](https://metacpan.org/pod/Stenciller)
- [Stenciller::Plugin::ToUnparsedText](https://metacpan.org/pod/Stenciller::Plugin::ToUnparsedText)
- [Pod::Weaver](https://metacpan.org/pod/Pod::Weaver)

# SOURCE

[https://github.com/Csson/p5-Pod-Elemental-Transformer-Stenciller](https://github.com/Csson/p5-Pod-Elemental-Transformer-Stenciller)

# HOMEPAGE

[https://metacpan.org/release/Pod-Elemental-Transformer-Stenciller](https://metacpan.org/release/Pod-Elemental-Transformer-Stenciller)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
