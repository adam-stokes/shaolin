package CI::Repo;

use Moo;
use namespace::autoclean;
use Data::Dumper;

has layer_list => (is => 'ro');
has charm_list => (is => 'ro');

sub sync_upstream {
    my ($self, $args) = @_;
    print "Syncing upstream\n";
}

1;
