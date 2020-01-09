package CI::Repo;

use Modern::Perl;
use Data::Dumper;
use Moo;
use Types::Standard qw(ArrayRef InstanceOf);
use Types::Path::Tiny qw(Path);
use YAML::Tiny;
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
    $self->system(qw(ls -l /home));
}

1;
