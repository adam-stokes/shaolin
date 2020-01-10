package CI::Repo;

use Modern::Perl;
use Data::Dumper;
use Types::Standard qw(ArrayRef);
use Types::Path::Tiny qw(Path);
use YAML::Tiny;
use Path::Tiny;
use File::chdir;
use URL::Encode qw(url_encode);

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

    my @repos;
    foreach my $file ( @{ $self->items } ) {
        my $yaml = YAML::Tiny->read_string( $file->absolute->slurp );
        for my $spec ( @{ $yaml->[0] } ) {
            push @repos, $spec;
        }
    }

    for my $item (@repos) {

        my $tmpdir = Path::Tiny->tempdir;
        local $CWD = $tmpdir;

        my ($spec) = keys %{$item};
        printf( "Processing %s\n", $spec );
        my %vals       = %{ $item->{$spec} };
        my $downstream = sprintf(
            "https://%s:%s\@github.com/%s",
            url_encode( $ENV{'CDKBOT_GH_USR'} ),
            url_encode( $ENV{'CDKBOT_GH_PSW'} ),
            $vals{downstream}
        );

        printf( "down -> %s\n", $downstream );
        printf( "up   -> %s\n", $vals{upstream} );

        $self->system("git clone $downstream");
    }
}

1;
