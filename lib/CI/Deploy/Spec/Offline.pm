package CI::Deploy::Spec::Offline;

use Modern::Perl;
use Types::Standard qw(Str);

use Moo;
use namespace::autoclean;

with 'CI';

has machine => ( is => 'ro', isa => Str, required => 1 );

sub execute {
    my $self = shift;

}

1;

__DATA__

@@ apt-mirror.list

set nthreads     20
set _tilde 0

deb http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse

deb-src http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse
clean http://archive.ubuntu.com/ubuntu


@@ cloudinit.yaml
? my $stash = shift;

cloudinit-userdata: |
  apt:
    primary:
      - arches: [i386, amd64]
        uri: http://<?= $stash->{hostname} ?>/ubuntu
    security:
      - arches: [i386, amd64]
        uri: http://<?= $stash->{hostname} ?>/ubuntu

@@ environment

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
HTTP_PROXY=http://localhost:3128
HTTPS_PROXY=http://localhost:3128
http_proxy=http://localhost:3128
https_proxy=http://localhost:3128

@@ squid.conf
? my $stash = shift;

acl lxd dst  <?= $stash->{lxdbr0_subnet} ?> # 10.254.86.0/24 whatever lxdbr0 is
http_access allow lxd

acl apt dst 172.31.5.0/24
http_access allow apt

acl rockscc dstdomain rocks.canonical.com
http_access allow rockscc

http_access allow localhost

http_access deny all
http_port 3128

@@ ssl.conf

? my $stash = shift;
[ req ]
prompt = no
default_bits = 4096
distinguished_name = req_distinguished_name
req_extensions = req_ext

[ req_distinguished_name ]
C=GB
ST=London
L=London
O=Canonical
OU=Canonical
CN=<?= $stash->{hostname} ?>

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1 = <?= $stash->{hostname} ?>
DNS.2 = <?= $stash->{hostname} ?>
IP.1 = <?= $stash->{hostname} ?>

@@ sstreams-mirror.conf

<VirtualHost *:443>
    ServerName sstreams.cdk-juju
    ServerAlias *
    DocumentRoot /var/spool/sstreams/
    SSLCACertificatePath /etc/ssl/certs
    SSLCertificateFile /etc/pki/tls/certs/mirror.crt
    SSLEngine On
    SSLCertificateKeyFile /etc/pki/tls/private/mirror.key
    LogLevel info
    ErrorLog /var/log/apache2/mirror-lxdkvm-error.log
    CustomLog /var/log/apache2/mirror-lxdkvm-access.log combined

    <Directory /var/spool/sstreams/>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>
</VirtualHost>

@@ ubuntu-mirror.conf

<VirtualHost *:80>
    ServerName cdk-juju
    ServerAlias *
    DocumentRoot /var/spool/apt-mirror/mirror/archive.ubuntu.com/
    LogLevel info
    ErrorLog /var/log/apache2/mirror-archive.ubuntu.com-error.log
    CustomLog /var/log/apache2/mirror-archive.ubuntu.com-access.log combined

    <Directory /var/spool/apt-mirror/>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>
</VirtualHost>

__END__

Offline spec for setting up a system
