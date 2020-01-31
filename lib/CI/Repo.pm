package CI::Repo;

use Modern::Perl;
use Types::Standard qw(ArrayRef);
use Types::Path::Tiny qw(Path);
use YAML::Tiny;
use Path::Tiny;
use File::chdir;
use URL::Encode qw(url_encode);
use URI;
use System::Info;
use Parallel::ForkManager;

use Moo;
use namespace::autoclean;

with 'CI';

has items => (
    is       => 'ro',
    isa      => ArrayRef->of(Path),
    coerce   => 1,
    required => 1
);

sub sync {
    my $self = shift;
    my $si = System::Info->new;
    my @repos;
    foreach my $file ( @{ $self->items } ) {
        my $yaml = YAML::Tiny->read_string( $file->absolute->slurp );
        for my $spec ( @{ $yaml->[0] } ) {
            push @repos, $spec;
        }
    }

    my $pm = Parallel::ForkManager->new($si->ncore);
  REPOS:
    for my $item (@repos) {
        $pm->start and next REPOS;

        my $tmpdir = Path::Tiny->tempdir;

        my ($spec)     = keys %{$item};
        my %vals       = %{ $item->{$spec} };
        my $downstream = sprintf(
            'https://%s:%s\@github.com/%s',
            url_encode( $ENV{'CDKBOT_GH_USR'} ),
            url_encode( $ENV{'CDKBOT_GH_PSW'} ),
            $vals{downstream}
        );

        my $upstream_path = URI->new( $vals{upstream} )->path;
        $upstream_path =~ s/^\///;
        $upstream_path =~ s/\.git//;
        my $downstream_path = $vals{downstream};
        $downstream_path =~ s/\.git//;

        if ( $upstream_path ne $downstream_path ) {
            say "Cloning $vals{upstream} <-> $downstream";
            $self->system("git clone $downstream $tmpdir");
            local $CWD = $tmpdir;
            $self->system('git config user.email cdkbot@gmail.com');
            $self->system("git config user.name cdkbot");
            $self->system("git config push.default simple");

            $self->system(
                sprintf( "git remote add upstream %s", $vals{upstream} ) );
            $self->system("git fetch upstream");
            $self->system("git checkout master");
            $self->system("git merge upstream/master");
            $self->system("git push origin");
        }
        $pm->finish;
    }
    $pm->wait_all_children;
}

1;
