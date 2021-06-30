# NAME

Pod::Elemental::Transformer::Stenciller - Injects content from textfiles transformed with Stenciller

<div>
    <p>
    <img src="https://img.shields.io/badge/perl-5.14+-blue.svg" alt="Requires Perl 5.14+" />
    <img src="https://img.shields.io/badge/coverage-88.6%25-orange.svg" alt="coverage 88.6%" />
    <a href="https://github.com/Csson/p5-Pod-Elemental-Transformer-Stenciller/actions?query=workflow%3Amakefile-test"><img src="https://img.shields.io/github/workflow/status/Csson/p5-Pod-Elemental-Transformer-Stenciller/makefile-test" alt="Build status at Github" /></a>
    </p>
</div>

# VERSION

Version 0.0301, released 2021-06-30.

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

3\. Add a Perl module:

    package A::Test::Module;

    1;

    __END__

    =pod

    =head1 NAME

    =head1 DESCRIPTION

    :stenciller ToUnparsedText file-with-stencils.stencil

The last line in the Perl module will result in the following:

- The textfile is parsed with [Stenciller](https://metacpan.org/pod/Stenciller)
- The textfile is then transformed using the [Stenciller::Plugin::ToUnparsedText](https://metacpan.org/pod/Stenciller::Plugin::ToUnparsedText) plugin.
- The ':stenciller ...' line in the pod is replaced with the transformed content.

## Pod hash

It is possible to filter stencils by index with an optional hash in the pod:

    :stenciller ToUnparsedText 1-test.stencil { stencils => [0, 2..4] }

This will only include the stencils with index 0, 2, 3 and 4 from `file-with-stencils.stencil`.

## Stencil hash

This module checks for the `to_pod` key in the stencil hash. If it has a true value (or doesn't exist) it is included in the transformation.

However, any stencil excluded by the ["Pod hash"](#pod-hash) is already disregarded. It is probably least confusing to choose **one** of these places to do all filtering.

# ATTRIBUTES

## directory

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Path::Tiny#Dir">Dir</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">required</td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>Path to directory where the stencil files are.</p>

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

This software is copyright (c) 2021 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
