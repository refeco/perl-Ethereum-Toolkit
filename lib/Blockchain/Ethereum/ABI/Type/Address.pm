package Blockchain::Ethereum::ABI::Type::Address;

use v5.26;
use strict;
use warnings;

# ABSTRACT: Solidity address type interface
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Allows you to define and instantiate a solidity address type:

    my $type = Blockchain::Ethereum::ABI::Address->new(
        signature => $signature,
        data      => $value
    );

    $type->encode();

In most cases you don't want to use this directly, use instead:

=over 4

=item * B<Encoder>: L<Blockchain::Ethereum::ABI::Encoder>

=item * B<Decoder>: L<Blockchain::Ethereum::ABI::Decoder>

=back

=cut

use parent 'Blockchain::Ethereum::ABI::Type';

sub _configure { return }

=method encode

Encodes the given data to the type of the signature

=over 4

=back

ABI encoded hex string

=cut

sub encode {
    my $self = shift;

    return $self->_encoded if $self->_encoded;
    $self->_push_static($self->pad_left(substr($self->{data}, 2)));

    return $self->_encoded;
}

=method decode

Decodes the given data to the type of the signature

=over 4

=back

String 0x prefixed address

=cut

sub decode {
    my $self = shift;

    return '0x' . substr $self->{data}->[0], -40;
}

1;
