package Blockchain::Ethereum::Transaction::EIP2930;

use v5.26;
use strict;
use warnings;

# ABSTRACT: Ethereum Access List transaction abstraction (EIP-2930)
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Transaction abstraction for EIP-2930 Access List transactions

    my $transaction = Blockchain::Ethereum::Transaction::EIP2930->new(
        nonce       => '0x0',
        gas_price   => '0x4A817C800',
        gas_limit   => '0x5208',
        to          => '0x3535353535353535353535353535353535353535',
        value       => parse_unit('1', ETH),
        data        => '0x',
        chain_id    => '0x1',
        access_list => [
            {
                address      => '0x1234567890123456789012345678901234567890',
                storage_keys => [
                    '0x0000000000000000000000000000000000000000000000000000000000000001',
                    '0x0000000000000000000000000000000000000000000000000000000000000002'
                ]
            }
        ]
    );

    my $key = Blockchain::Ethereum::Keystore::Key->new(
        private_key => pack "H*",
        '4646464646464646464646464646464646464646464646464646464646464646'
    );

    $key->sign_transaction($transaction);

    my $raw_transaction = $transaction->serialize;

=cut

use parent 'Blockchain::Ethereum::Transaction';

use constant TRANSACTION_PREFIX => pack("H*", '01');

sub new {
    my ($class, %args) = @_;

    my $self = $class->SUPER::new(%args);

    foreach (qw( gas_price access_list )) {
        $self->{$_} = $args{$_} if exists $args{$_};
    }

    bless $self, $class;
    return $self;
}

sub gas_price {
    return shift->{gas_price};
}

sub access_list {
    return shift->{access_list} // [];
}

=method serialize

Encodes the given transaction parameters to RLP

=over 4

=back

Returns the RLP encoded transaction bytes

=cut

sub serialize {
    my $self = shift;

    my @params =
        ($self->chain_id, $self->nonce, $self->gas_price, $self->gas_limit, $self->to, $self->value, $self->data, $self->_encode_access_list,);

    @params = $self->_normalize_params(\@params)->@*;

    push(@params, $self->v, $self->r, $self->s)
        if $self->v && $self->r && $self->s;

    # eip-2930 transactions must be prefixed by 1 that is the
    # transaction type
    return TRANSACTION_PREFIX . $self->rlp->encode(\@params);
}

1;
