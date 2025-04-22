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

This distribution merges the functionality of the following previously separate modules:

=over 4

=item *

L<https://metacpan.org/dist/Blockchain-Ethereum-ABI>

=item *

L<https://metacpan.org/dist/Blockchain-Ethereum-RLP>

=item *

L<https://metacpan.org/dist/Blockchain-Ethereum-Transaction>

=item *

L<https://metacpan.org/dist/Blockchain-Ethereum-Keystore>

=back

These modules are now bundled together in a single distribution to simplify usage, packaging, and long-term maintenance.

=head1 INCLUDED MODULES

=over 4

=item *

L<Blockchain::Ethereum::ABI> — Encode/decode Ethereum ABI function signatures and parameters.

=item *

L<Blockchain::Ethereum::RLP> — Recursive Length Prefix (RLP) encoding and decoding implementation.

=item *

L<Blockchain::Ethereum::Transaction> — Create, serialize, and sign Ethereum transactions (Legacy and EIP-155).

=item *

L<Blockchain::Ethereum::Keystore> — Load and decrypt Ethereum V3 JSON keystore files.

=back

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