package CI::Repo;

use Moo;
use namespace::autoclean;
use Data::Dumper;

has layer_list => (is => 'ro');
has charm_list => (is => 'ro');

sub init {
    my ($self, $args) = @_;
    print Dumper($self);
}

1;
