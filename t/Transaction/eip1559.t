#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Blockchain::Ethereum::Transaction::EIP1559;
use Blockchain::Ethereum::Keystore::Key;

subtest "contract deployment => remix storage contract" => sub {
    # storage contract from remix
    my $compiled_contract =
        '0x608060405234801561001057600080fd5b50610150806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80632e64cec11461003b5780636057361d14610059575b600080fd5b610043610075565b60405161005091906100a1565b60405180910390f35b610073600480360381019061006e91906100ed565b61007e565b005b60008054905090565b8060008190555050565b6000819050919050565b61009b81610088565b82525050565b60006020820190506100b66000830184610092565b92915050565b600080fd5b6100ca81610088565b81146100d557600080fd5b50565b6000813590506100e7816100c1565b92915050565b600060208284031215610103576101026100bc565b5b6000610111848285016100d8565b9150509291505056fea2646970667358221220322c78243e61b783558509c9cc22cb8493dde6925aa5e89a08cdf6e22f279ef164736f6c63430008120033';

    my $transaction = Blockchain::Ethereum::Transaction::EIP1559->new(
        nonce                    => '0x0',
        max_fee_per_gas          => '0x9',
        max_priority_fee_per_gas => '0x0',
        gas_limit                => '0x1DE2B9',
        value                    => '0x0',
        data                     => $compiled_contract,
        chain_id                 => '0x539'
    );

    my $key = Blockchain::Ethereum::Keystore::Key->new(
        private_key => pack "H*",
        '4646464646464646464646464646464646464646464646464646464646464646'
    );

    $key->sign_transaction($transaction);

    my $raw_transaction = $transaction->serialize;

    is(unpack("H*", $raw_transaction),
        '02f901c3820539808009831de2b98080b90170608060405234801561001057600080fd5b50610150806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80632e64cec11461003b5780636057361d14610059575b600080fd5b610043610075565b60405161005091906100a1565b60405180910390f35b610073600480360381019061006e91906100ed565b61007e565b005b60008054905090565b8060008190555050565b6000819050919050565b61009b81610088565b82525050565b60006020820190506100b66000830184610092565b92915050565b600080fd5b6100ca81610088565b81146100d557600080fd5b50565b6000813590506100e7816100c1565b92915050565b600060208284031215610103576101026100bc565b5b6000610111848285016100d8565b9150509291505056fea2646970667358221220322c78243e61b783558509c9cc22cb8493dde6925aa5e89a08cdf6e22f279ef164736f6c63430008120033c080a0a34016bb162ce8e143e1ad516105732eb4f38c7005a0bb13b15dfeacf109ba46a0393d43092824821af1f818de4fcb915c476478b2265c9fdca5d09ef15f16e3d8'
    );

    my $rlp = Blockchain::Ethereum::RLP->new();
    # substring to remove the 02
    my $decoded = $rlp->decode(substr($raw_transaction, 1));

    is hex $decoded->[-3], 0, 'correct eip155 v value for contract creation transaction';

};

subtest "eth transfer" => sub {
    my $transaction = Blockchain::Ethereum::Transaction::EIP1559->new(
        nonce                    => '0x1',
        max_fee_per_gas          => '0x9',
        max_priority_fee_per_gas => '0x0',
        gas_limit                => '0x5208',
        to                       => '0x3535353535353535353535353535353535353535',
        value                    => '0xDE0B6B3A7640000',
        chain_id                 => '0x539'
    );

    my $key = Blockchain::Ethereum::Keystore::Key->new(
        private_key => pack "H*",
        '4646464646464646464646464646464646464646464646464646464646464646'
    );

    $key->sign_transaction($transaction);

    my $raw_transaction = $transaction->serialize;

    is(unpack("H*", $raw_transaction),
        '02f86c820539018009825208943535353535353535353535353535353535353535880de0b6b3a764000080c080a070816c3d026c13a53e98e5dc414398e9dcdf23e440e777114a3e04810e0dfb5da07d732e6b7f847b06d2baed033772d78407da8f4010fa9300df79f2209ba4c7a0'
    );

    my $rlp = Blockchain::Ethereum::RLP->new();
    # substring to remove the 02
    my $decoded = $rlp->decode(substr($raw_transaction, 1));

    is hex $decoded->[-3], 0, 'correct eip155 v value for contract creation transaction';

};

done_testing;
