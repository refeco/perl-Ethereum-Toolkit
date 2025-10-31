use strict;
use warnings;

use Blockchain::Ethereum::Key;
use Blockchain::Ethereum::Keystore::Seed;

# generating a new address
my $key = Blockchain::Ethereum::Key->new();
printf "%s\n", $key->address;

# importing private key
$key = Blockchain::Ethereum::Key->new(
    private_key => pack "H*",
    '4646464646464646464646464646464646464646464646464646464646464646'
);
printf "%s\n", $key->address;

# hdwallet
my $wallet = Blockchain::Ethereum::Keystore::Seed->new();
$key = $wallet->derive_key(0);
printf "%s\n", $key->address;
$key = $wallet->derive_key(1);
printf "%s\n", $key->address;

