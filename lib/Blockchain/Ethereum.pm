package Blockchain::Ethereum;

use v5.26;
use strict;
use warnings;

# ABSTRACT: A low-level Ethereum toolkit in Perl
# AUTHORITY
# VERSION

=head1 NAME

Blockchain::Ethereum::Toolkit - A low-level Ethereum toolkit in Perl

=head1 DESCRIPTION

A low-level Ethereum toolkit written in Perl, combining core utilities for working with Ethereum's internal data structures.

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

=head1 MAINTENANCE STATUS

This toolkit is feature-complete and currently not under active development.

However:

=over 4

=item *

Pull requests are welcome

=item *

Bug reports will be reviewed

=item *

I may occasionally address issues

=back

If you use this project and want to contribute improvements or features, feel free to open a pull request.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the terms of the MIT license. See the LICENSE file for details.

=cut

1;
