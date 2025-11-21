package Blockchain::Ethereum;

use v5.26;
use strict;
use warnings;

# ABSTRACT: A Ethereum toolkit in Perl
# AUTHORITY
# VERSION

=head1 DESCRIPTION

A Ethereum toolkit written in Perl, combining core utilities for working with Ethereum's internal data structures.

This distribution merges the functionality of previously separate modules into a single toolkit, including:

=over 4

=item *

ABI encoding and decoding

=item *

RLP serialization

=item *

Transaction creation and signing

=item *

Keystore encryption and decryption

=back

These modules are now bundled together in a single distribution to simplify usage, packaging, and long-term maintenance.

=head1 INSTALLATION

Install via CPAN:

  cpanm Blockchain::Ethereum

Or install manually:

  git clone https://github.com/refeco/perl-Ethereum-Toolkit.git
  cd perl-Ethereum-Toolkit
  dzil install

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the terms of the MIT license. See the LICENSE file for details.

=cut

1;
