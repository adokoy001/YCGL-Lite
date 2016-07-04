package YCGL::Lite::Plack;
use strict;
use warnings;
use Mouse;
use Plack::Runner;
use Plack::App::File;

sub plackup_static{
    my $self = shift;
    my $public_dir = shift;
    my $app = Plack::App::File->new(root => $public_dir)->to_app;
    my $runner = Plack::Runner->new;
    $runner->parse_options(@ARGV);
    $runner->run($app);
}


__PACKAGE__->meta->make_immutable();

1;
