package CI::Cmd::Repo::Sync;

use Modern::Perl;
use Moo;
use Getopt::Long;
with 'MooX::Commander::HasOptions', 'CI';
use namespace::autoclean;

sub _build_options {
    return (
        "items=s" => $self->options->{items}
    );
}

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
    say $self->dump(@_);
    say $self->dump( $self->options->{items} );
}

1;
