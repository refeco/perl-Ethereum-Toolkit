# NAME

Blockchain::Ethereum - A Ethereum toolkit in Perl

# VERSION

version 0.021

# DESCRIPTION

A Ethereum toolkit written in Perl, combining core utilities for working with Ethereum's internal data structures.

- [Blockchain::Ethereum::ABI](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3AABI) ABI (En/De)coding
- [Blockchain::Ethereum::RLP](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ARLP) RLP (De)Serialization
- [Blockchain::Ethereum::Transaction](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction) Ethereum Transaction Abstraction
    - [Blockchain::Ethereum::Transaction::Legacy](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction%3A%3ALegacy)  - Legacy Transaction
    - [Blockchain::Ethereum::Transaction::EIP1559](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction%3A%3AEIP1559) - Fee Market Transaction
    - [Blockchain::Ethereum::Transaction::EIP2930](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction%3A%3AEIP2930) - Optional Access Lists Transaction
    - [Blockchain::Ethereum::Transaction::EIP4844](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction%3A%3AEIP4844) - Blob Transaction
- [Blockchain::Ethereum::Keystore](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3AKeystore) Keystore File Abstraction (v3)

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
