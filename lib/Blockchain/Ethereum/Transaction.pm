package Blockchain::Ethereum::Transaction;

use v5.26;
use strict;
use warnings;

# ABSTRACT: Ethereum transaction abstraction
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Ethereum transaction abstraction for signing and generating raw transactions
    # parameters can be hexadecimal strings or Math::BigInt instances
    my $transaction = Blockchain::Ethereum::Transaction::EIP1559->new(
        nonce                    => '0x0',
        max_fee_per_gas          => '0x9',
        max_priority_fee_per_gas => '0x0',
        gas_limit                => '0x1DE2B9',
        to                       => '0x3535353535353535353535353535353535353535'
        value                    => parse_unit('1', ETH),
        data                     => '0x',
        chain_id                 => '0x539'
    );

    my $key = Blockchain::Ethereum::Keystore::Key->new(
        private_key => pack "H*",
        '4646464646464646464646464646464646464646464646464646464646464646'
    );

    $key->sign_transaction($transaction);

    my $raw_transaction = $transaction->serialize;

    print unpack("H*", $raw_transaction);

Supported transaction types:

=over 4

=item * B<Legacy>

=item * B<EIP2930 Access List>

=item * B<EIP1559 Fee Market>

=back

=cut

use Carp;
use Crypt::Digest::Keccak256 qw(keccak256);
use Scalar::Util             qw(blessed looks_like_number);
use Math::BigInt;

use Blockchain::Ethereum::RLP;

sub new {
    my ($class, %args) = @_;

    my $self = bless {}, $class;

    foreach (qw(chain_id nonce gas_limit to value data v r s)) {
        $self->{$_} = $args{$_} if exists $args{$_};
    }

    return $self;
}

sub rlp {
    my $self = shift;

    return $self->{rlp} //= Blockchain::Ethereum::RLP->new;
}

sub chain_id {
    return shift->{chain_id};
}

sub nonce {
    return shift->{nonce};
}

sub gas_limit {
    return shift->{gas_limit};
}

sub to {
    return shift->{to} // '';
}

sub value {
    return shift->{value} // '0x0';
}

sub data {
    return shift->{data} // '';
}

sub v {
    return shift->{v};
}

sub set_v {
    my ($self, $v) = @_;
    $self->{v} = $v;
}

sub r {
    return shift->{r};
}

sub set_r {
    my ($self, $r) = @_;
    $self->{r} = $r;
}

sub s {
    my $self = shift;
    return $self->{s};
}

sub set_s {
    my ($self, $s) = @_;
    $self->{s} = $s;
}

=method serialize

To be implemented by the child classes, encodes the given transaction parameters to RLP

=over 4

=back

Returns the RLP encoded transaction bytes

=cut

sub serialize {
    croak "serialize method not implemented";
}

=method hash

SHA3 Hash the serialized transaction object

=over 4

=back

Returns the SHA3 transaction hash bytes

=cut

sub hash {
    my $self = shift;

    return keccak256($self->serialize);
}

# Hex conversion
sub _normalize_params {
    my ($self, $params) = @_;

    return [
        map {
            !defined $_
                ? $_                                                                        # undefined
                : blessed $_ && $_->isa('Math::BigInt')  ? $_->as_hex                       # BigInt
                : /^0x/i                                 ? $_                               # hex string
                : looks_like_number($_) && $_ == int($_) ? Math::BigInt->new($_)->as_hex    # integer/numeric string
                : $_                                                                        # anything else
        } @$params
    ];
}

=method _encode_access_list

Internal method to encode the access list for RLP serialization

=over 4

=back

Returns the properly formatted access list for RLP encoding

=cut

sub _encode_access_list {
    my $self = shift;

    my $access_list = $self->access_list();

    # If no access list, return empty array
    return [] unless @$access_list;

    my @encoded_list;

    for my $entry (@$access_list) {
        my $address      = $entry->{address}      // '';
        my $storage_keys = $entry->{storage_keys} // [];

        push @encoded_list, [$address, $storage_keys];
    }

    return \@encoded_list;
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

    # eip-1559 and eip-2930 uses y-parity directly as the v value
    my $v = sprintf("0x%x", $y_parity);
    $self->set_v($v);
    return $v;
}

1;
