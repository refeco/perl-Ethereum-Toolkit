#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use File::Temp    qw(tempfile);
use JSON::MaybeXS qw(decode_json);
use Blockchain::Ethereum::Keystore::File;
use Blockchain::Ethereum::Key;

# Test data
my $private_key_hex   = "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d";
my $private_key_bytes = pack "H*", $private_key_hex;
my $password          = "testpassword";

subtest "from_file - v3 pbkdf2" => sub {
    my $keyfile = Blockchain::Ethereum::Keystore::File->from_file("./t/Keystore/resources/pbkdf2_v3.json", $password);

    isa_ok $keyfile,              'Blockchain::Ethereum::Keystore::File';
    isa_ok $keyfile->private_key, 'Blockchain::Ethereum::Keystore::Key';
    is $keyfile->private_key->export, $private_key_bytes, 'private key matches';
    is $keyfile->password,            $password,          'password stored correctly';

    # Test against actual file data
    is $keyfile->version,    3,                                                                  'version is 3';
    is $keyfile->id,         '3198bc9c-6672-5ab3-d995-4942343ae5b6',                             'ID matches file data';
    is $keyfile->cipher,     'AES128_CTR',                                                       'cipher is correct';
    is $keyfile->iv,         '6087dab2f9fdbbfaddc31a909735c1e6',                                 'IV matches file data';
    is $keyfile->ciphertext, '5318b4d5bcd28de64ee5559e671353e16f075ecae9f99c7a79a38af5f869aa46', 'ciphertext matches file data';
    is $keyfile->mac,        '517ead924a9d0dc3124507e3393d175ce3ff7c1e96529c6c555ce9e51205e9b2', 'MAC matches file data';

    # Test KDF parameters
    isa_ok $keyfile->kdf, 'Blockchain::Ethereum::Keystore::KDF';
    is $keyfile->kdf->algorithm, 'pbkdf2',                                                           'KDF algorithm is pbkdf2';
    is $keyfile->kdf->dklen,     32,                                                                 'KDF dklen is correct';
    is $keyfile->kdf->c,         262144,                                                             'KDF iteration count is correct';
    is $keyfile->kdf->prf,       'hmac-sha256',                                                      'KDF PRF is correct';
    is $keyfile->kdf->salt,      'ae3cd4e7013836a3df6bd7241b12db061dbe2c6785853cce422d148a624ce0bd', 'KDF salt matches file data';
};

subtest "from_file - v3 scrypt" => sub {
    my $keyfile = Blockchain::Ethereum::Keystore::File->from_file("./t/Keystore/resources/scrypt_v3.json", $password);

    isa_ok $keyfile,              'Blockchain::Ethereum::Keystore::File';
    isa_ok $keyfile->private_key, 'Blockchain::Ethereum::Keystore::Key';
    is $keyfile->private_key->export, $private_key_bytes, 'private key matches';
    is $keyfile->password,            $password,          'password stored correctly';

    # Test against actual file data
    is $keyfile->version,    3,                                                                  'version is 3';
    is $keyfile->id,         '3198bc9c-6672-5ab3-d995-4942343ae5b6',                             'ID matches file data';
    is $keyfile->cipher,     'AES128_CTR',                                                       'cipher is correct';
    is $keyfile->iv,         '83dbcc02d8ccb40e466191a123791e0e',                                 'IV matches file data';
    is $keyfile->ciphertext, 'd172bf743a674da9cdad04534d56926ef8358534d458fffccd4e6ad2fbde479c', 'ciphertext matches file data';
    is $keyfile->mac,        '2103ac29920d71da29f15d75b4a16dbe95cfd7ff8faea1056c33131d846e3097', 'MAC matches file data';

    # Test KDF parameters
    isa_ok $keyfile->kdf, 'Blockchain::Ethereum::Keystore::KDF';
    is $keyfile->kdf->algorithm, 'scrypt',                                                           'KDF algorithm is scrypt';
    is $keyfile->kdf->dklen,     32,                                                                 'KDF dklen is correct';
    is $keyfile->kdf->n,         262144,                                                             'KDF n parameter is correct';
    is $keyfile->kdf->p,         8,                                                                  'KDF p parameter is correct';
    is $keyfile->kdf->r,         1,                                                                  'KDF r parameter is correct';
    is $keyfile->kdf->salt,      'ab0c7876052600dd703518d6fc3fe8984592145b591fc8fb5c6d43190334ba19', 'KDF salt matches file data';
};

subtest "lazy initialization" => sub {
    my $key     = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    my $keyfile = Blockchain::Ethereum::Keystore::File->new(
        private_key => $key,
        password    => $password
    );

    # Test lazy accessors
    is $keyfile->cipher, 'AES128_CTR', 'cipher defaults correctly';
    ok $keyfile->ciphertext, 'ciphertext is generated';
    ok $keyfile->iv,         'IV is generated';
    isa_ok $keyfile->kdf, 'Blockchain::Ethereum::Keystore::KDF';
    like $keyfile->id, qr/^[0-9a-f]{32}$/, 'ID has correct format';
    ok $keyfile->mac, 'MAC is generated';
};

subtest "write_to_file - basic" => sub {
    my $key     = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    my $keyfile = Blockchain::Ethereum::Keystore::File->new(
        private_key => $key,
        password    => $password
    );

    my ($fh, $filename) = tempfile();
    close $fh;

    eval { $keyfile->write_to_file($filename) };
    ok !$@,          'write_to_file succeeds';
    ok -f $filename, 'file was created';

    # Verify we can read it back
    my $loaded = Blockchain::Ethereum::Keystore::File->from_file($filename, $password);
    is $loaded->private_key->export, $private_key_bytes, 'round-trip preserves key';

    unlink $filename;
};

subtest "write_to_file - password change" => sub {
    my $key     = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    my $keyfile = Blockchain::Ethereum::Keystore::File->new(
        private_key => $key,
        password    => $password
    );

    my ($fh, $filename) = tempfile();
    close $fh;

    my $new_password = "newpassword";

    # Store original values
    my $original_mac        = $keyfile->mac;
    my $original_ciphertext = $keyfile->ciphertext;

    eval { $keyfile->write_to_file($filename, $new_password) };
    ok !$@, 'write_to_file with new password succeeds';

    # Verify password was changed
    is $keyfile->password, $new_password, 'password was updated';

    # Verify cryptographic fields were regenerated
    isnt $keyfile->mac,        $original_mac,        'MAC was regenerated';
    isnt $keyfile->ciphertext, $original_ciphertext, 'ciphertext was regenerated';

    # Verify we can read with new password
    my $loaded = Blockchain::Ethereum::Keystore::File->from_file($filename, $new_password);
    is $loaded->private_key->export, $private_key_bytes, 'key preserved after password change';

    # Verify old password no longer works
    eval { Blockchain::Ethereum::Keystore::File->from_file($filename, $password) };
    like $@, qr/Invalid password/, 'old password rejected';

    unlink $filename;
};

subtest "error conditions - constructor" => sub {
    eval { Blockchain::Ethereum::Keystore::File->new };
    like $@, qr/Missing required parameter/, 'constructor requires parameters';

    eval { Blockchain::Ethereum::Keystore::File->new(password => $password) };
    like $@, qr/Missing required parameter/, 'constructor requires private_key';

    my $key = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    eval { Blockchain::Ethereum::Keystore::File->new(private_key => $key) };
    like $@, qr/Missing required parameter/, 'constructor requires password';

    eval { Blockchain::Ethereum::Keystore::File->new(private_key => "not_a_key_object", password => $password) };
    like $@, qr/must be a Blockchain::Ethereum::Keystore::Key instance/, 'validates private_key type';
};

subtest "error conditions - from_file" => sub {
    eval { Blockchain::Ethereum::Keystore::File->from_file("nonexistent.json", $password) };
    like $@, qr/No such file or directory/, 'from_file handles missing file';

    eval { Blockchain::Ethereum::Keystore::File->from_file("./t/Keystore/resources/scrypt_v3.json", "wrongpassword") };
    like $@, qr/Invalid password or corrupted keystore/, 'from_file validates password';
};

subtest "MAC verification" => sub {
    # Load a valid keystore
    my $keyfile = Blockchain::Ethereum::Keystore::File->from_file("./t/Keystore/resources/scrypt_v3.json", $password);

    # MAC should be verified during loading (no exception = success)
    ok 1, 'MAC verification passed during from_file';

    # Test that MAC is properly generated for new keystores
    my $key         = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    my $new_keyfile = Blockchain::Ethereum::Keystore::File->new(
        private_key => $key,
        password    => $password
    );

    ok $new_keyfile->mac, 'MAC generated for new keystore';
    like $new_keyfile->mac, qr/^[0-9a-f]+$/i, 'MAC has hex format';
};

subtest "keystore format compliance" => sub {
    my $key     = Blockchain::Ethereum::Keystore::Key->new(private_key => $private_key_bytes);
    my $keyfile = Blockchain::Ethereum::Keystore::File->new(
        private_key => $key,
        password    => $password
    );

    my ($fh, $filename) = tempfile;
    close $fh;

    $keyfile->write_to_file($filename);

    # Read the JSON directly to verify format
    my $json_content = do {
        open my $fh, '<', $filename or die $!;
        local $/;
        <$fh>;
    };

    my $json_data = decode_json($json_content);

    # Verify required fields
    is $json_data->{version}, 3, 'JSON has version 3';
    ok $json_data->{id},                 'JSON has id field';
    ok $json_data->{crypto},             'JSON has crypto field';
    ok $json_data->{crypto}{cipher},     'JSON has cipher field';
    ok $json_data->{crypto}{ciphertext}, 'JSON has ciphertext field';
    ok $json_data->{crypto}{mac},        'JSON has mac field';
    ok $json_data->{crypto}{kdf},        'JSON has kdf field';
    ok $json_data->{crypto}{kdfparams},  'JSON has kdfparams field';

    unlink $filename;
};

done_testing;
