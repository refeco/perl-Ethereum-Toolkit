package Blockchain::Ethereum::ABI::Decoder;

use v5.26;
use strict;
use warnings;

# ABSTRACT: ABI utility for decoding ethereum contract arguments
# AUTHORITY
# VERSION

=head1 SYNOPSIS

Allows you to decode contract ABI response

    my $decoder = Blockchain::Ethereum::ABI::Decoder->new();
    $decoder
        ->append('uint256')
        ->append('bytes[]')
        ->decode('0x...');

=cut

use Carp;

use Blockchain::Ethereum::ABI::Type;
use Blockchain::Ethereum::ABI::Type::Tuple;

sub new {
    my $class = shift;
    my $self  = {
        instances => [],
    };

    return bless $self, $class;
}

=method append

Appends type signature to the decoder.

Usage:

    append(signature) -> L<Blockchain::Ethereum::ABI::Encoder>

=over 4

=item * C<$param> type signature e.g. uint256

=back

Returns C<$self>

=cut

sub append {
    my ($self, $param) = @_;

    push $self->{instances}->@*, Blockchain::Ethereum::ABI::Type->new(signature => $param);
    return $self;
}

=method decode

Decodes appended signatures

Usage:

    decode() -> []

=over 4

=back

Returns an array reference containing all decoded values

=cut

sub decode {
    my ($self, $hex_data) = @_;

    croak 'Invalid hexadecimal value ' . $hex_data // 'undef'
        unless $hex_data =~ /^(?:0x|0X)?([a-fA-F0-9]+)$/;

    my $hex  = $1;
    my @data = unpack("(A64)*", $hex);

    my $tuple = Blockchain::Ethereum::ABI::Type::Tuple->new;
    $tuple->{instances} = $self->{instances};
    $tuple->{data}      = \@data;
    my $data = $tuple->decode;

    $self->_clean;
    return $data;
}

sub _clean {
    my $self = shift;

    $self->{instances} = [];
}

1;
