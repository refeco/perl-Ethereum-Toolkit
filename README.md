# NAME

Blockchain::Ethereum - A low-level Ethereum toolkit in Perl

# VERSION

version 0.001

# DESCRIPTION

A low-level Ethereum toolkit written in Perl, combining core utilities for working with Ethereum's internal data structures.

This distribution merges the functionality of the following previously separate modules:

- [https://metacpan.org/dist/Blockchain-Ethereum-ABI](https://metacpan.org/dist/Blockchain-Ethereum-ABI)
- [https://metacpan.org/dist/Blockchain-Ethereum-RLP](https://metacpan.org/dist/Blockchain-Ethereum-RLP)
- [https://metacpan.org/dist/Blockchain-Ethereum-Transaction](https://metacpan.org/dist/Blockchain-Ethereum-Transaction)
- [https://metacpan.org/dist/Blockchain-Ethereum-Keystore](https://metacpan.org/dist/Blockchain-Ethereum-Keystore)

These modules are now bundled together in a single distribution to simplify usage, packaging, and long-term maintenance.

# NAME

Blockchain::Ethereum::Toolkit - A low-level Ethereum toolkit in Perl

# INCLUDED MODULES

- [Blockchain::Ethereum::ABI](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3AABI) — Encode/decode Ethereum ABI function signatures and parameters.
- [Blockchain::Ethereum::RLP](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ARLP) — Recursive Length Prefix (RLP) encoding and decoding implementation.
- [Blockchain::Ethereum::Transaction](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction) — Create, serialize, and sign Ethereum transactions (Legacy and EIP-155).
- [Blockchain::Ethereum::Keystore](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3AKeystore) — Load and decrypt Ethereum V3 JSON keystore files.

# INSTALLATION

Install via CPAN:

```
cpanm Blockchain::Ethereum
```

Or install manually:

```
git clone https://github.com/refeco/perl-Ethereum-Toolkit.git
cd perl-Ethereum-Toolkit
dzil install
```

# MAINTENANCE STATUS

This toolkit is feature-complete and currently not under active development.

However:

- Pull requests are welcome
- Bug reports will be reviewed
- I may occasionally address issues

If you use this project and want to contribute improvements or features, feel free to open a pull request.

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the terms of the MIT license. See the LICENSE file for details.

# AUTHOR

REFECO <refeco@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2022 by REFECO.

This is free software, licensed under:

```
The MIT (X11) License
```
