package Blockchain::Ethereum::ABI::Type::String;

use v5.26;
use strict;
use warnings;

# ABSTRACT: Solidity string type interface
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Allows you to define and instantiate a solidity string type:

    my $type = Blockchain::Ethereum::ABI::String->new(
        signature => $signature,
        data      => $value
    );

    $type->encode();
    ...

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

    my $hex = unpack("H*", $self->{data});

    # for dynamic length basic types the length must be included
    $self->_push_dynamic($self->_encode_length(length(pack("H*", $hex))));
    $self->_push_dynamic($self->pad_right($hex));

    return $self->_encoded;
}

=method decode

Decodes the given data to the type of the signature

=over 4

=back

String

=cut

sub decode {
    my $self = shift;

    my @data = $self->{data}->@*;

    my $size          = hex shift @data;
    my $string_data   = join('', @data);
    my $packed_string = pack("H*", $string_data);
    return substr($packed_string, 0, $size);
}

1;
