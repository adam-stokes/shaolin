package CI::Repo;

use Modern::Perl;
use Data::Dumper;
use Moo;
use Types::Standard qw(ArrayRef InstanceOf);
use Types::Path::Tiny qw(Path);
use YAML::Tiny;
use namespace::autoclean;

has items => (
    is       => 'ro',
    isa      => ArrayRef->of(Path),
    coerce   => 1,
    required => 1
);

sub sync_upstream {
    my $self = shift;
    my $yaml = YAML::Tiny->read_string($self->items->[0]->slurp);
    say Dumper($yaml);
    say "Syncing upstream\n";
}

1;
