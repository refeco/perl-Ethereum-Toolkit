package Blockchain::Ethereum::Transaction::Legacy;

use v5.26;
use strict;
use warnings;

# ABSTRACT: Ethereum Legacy transaction abstraction
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Transaction abstraction for Legacy transactions

     my $transaction = Blockchain::Ethereum::Transaction::Legacy->new(
        nonce     => '0x9',
        gas_price => '0x4A817C800',
        gas_limit => '0x5208',
        to        => '0x3535353535353535353535353535353535353535',
        value     => '0xDE0B6B3A7640000',
        chain_id  => '0x1'

    my $key = Blockchain::Ethereum::Keystore::Key->new(
        private_key => pack "H*",
        '4646464646464646464646464646464646464646464646464646464646464646'
    );

    $key->sign_transaction($transaction);

    my $raw_transaction = $transaction->serialize;

=cut

use parent 'Blockchain::Ethereum::Transaction';

sub new {
    my ($class, %args) = @_;

    my $self = $class->SUPER::new(%args);

    foreach (qw( gas_price )) {
        $self->{$_} = $args{$_} if exists $args{$_};
    }

    bless $self, $class;
    return $self;
}

sub gas_price {
    return shift->{gas_price};
}

=method serialize

Encodes the given transaction parameters to RLP

=over 4

=back

Returns the RLP encoded transaction bytes

=cut

sub serialize {
    my $self = shift;

    my @params = (
        $self->nonce,    #
        $self->gas_price,
        $self->gas_limit,
        $self->to,
        $self->value,
        $self->data,
    );

    @params = $self->_normalize_params(\@params)->@*;

    if ($self->v && $self->r && $self->s) {
        push(@params, $self->v, $self->r, $self->s);
    } else {
        push(@params, $self->chain_id, '0x', '0x');
    }

    return $self->rlp->encode(\@params);
}

=method generate_v

Generate the transaction v field using the given y-parity

=over 4

=item * C<$y_parity> y-parity

=back

Returns the v hexadecimal value also sets the v fields from transaction

=cut

sub generate_v {
    my ($self, $y_parity) = @_;

    my $v = sprintf("0x%x", (hex $self->chain_id) * 2 + 35 + $y_parity);

    $self->set_v($v);
    return $v;
}

1;
