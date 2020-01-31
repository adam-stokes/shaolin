package CI::Cmd::Repo::Sync;

use Modern::Perl;
use CI::Repo;
use Moo;
use Getopt::Long;
with 'MooX::Commander::HasOptions', 'CI';
use namespace::autoclean;

sub _build_options {
    return [
        "items=s@"
    ];
}

sub usage {
    return <<"EOF";
usage: monk repo sync [options]

 Sync upstream Repos

 OPTIONS
   --items  The yaml spec of upstream items to Sync, can be repeated for multiple

EOF
}

sub go {
    my ($self) = @_;
    say $self->dump(@_);
    say $self->dump( $self->options->{items} );
    my $repo = CI::Repo->new(items => $self->options->{items});
    $repo->sync;
}

1;
