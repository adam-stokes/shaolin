package CI;

use Modern::Perl;
use Carp;
use Data::Dumper();
use Command::Runner;
use Moo::Role;
use namespace::autoclean;

use constant DEBUG  => $ENV{MONK_DEBUG}  || 0;

sub dump {
  return Data::Dumper->new([$_[1]])->Indent(1)->Terse(1)->Sortkeys(1)->Dump;
}

sub abort {
  my ($self, $format, @args) = @_;
  my $message = @args ? sprintf $format, @args : $format;

  Carp::confess("!! $message") if DEBUG;
  die "!! $message\n";
}

sub system {
    my ($self, $cmd) = @_;
    my $runner = Command::Runner->new(
        command => $cmd,
        stdout  => sub { warn "$_[0]\n" },
        stderr  => sub { warn "err: $_[0]\n" },
        );
    my $res = $runner->run;
    return $res;
}

1;
