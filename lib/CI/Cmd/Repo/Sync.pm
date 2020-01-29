package CI::Cmd::Repo::Sync;

use Modern::Perl;
use Moo;
with 'MooX::Commander::HasOptions';
use namespace::autoclean;

sub usage {
    return <<"EOF";
usage: monk repo sync [options]

 Sync upstream Repos

 OPTIONS
   --items  The yaml spec of upstream items to Sync

EOF
}

sub go {
    my ($self) = @_;
    say $self->options->{items};
}

1;
