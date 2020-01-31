package CI::Cmd::Repo;

use Modern::Perl;
use Data::Dumper;
use Moo;
with 'MooX::Commander::HasSubcommands';

use namespace::autoclean;

sub usage {
    return <<"END_USAGE";

    REPO Management - monk repo

    SUBCOMMANDS:
      sync - Sync upstream repos

END_USAGE
}

1;
