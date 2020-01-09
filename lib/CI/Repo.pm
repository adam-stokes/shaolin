package CI::Repo;

use Modern::Perl;
use Data::Dumper;
use Types::Standard qw(ArrayRef InstanceOf);
use Types::Path::Tiny qw(Path);
use YAML::Tiny;
use Path::Tiny;
use File::chdir;

use Moo;
use namespace::autoclean;

with 'CI';

has items => (
    is       => 'ro',
    isa      => ArrayRef->of(Path),
    coerce   => 1,
    required => 1
);

sub forks {
    my $self = shift;

    my $yaml = YAML::Tiny->read_string($self->items->[0]->slurp);
    say $self->dump($yaml);
    say "Syncing upstream\n";

    local $CWD = Path::Tiny->tempdir( CLEANUP => 0);
    $self->system(qw(pwd));
}

1;
