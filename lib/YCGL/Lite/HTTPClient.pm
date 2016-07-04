package YCGL::Lite::HTTPClient;
use strict;
use warnings;
use utf8;
use Mouse;
use WWW::Mechanize;

sub get{
    my $self = shift;
    my $url = shift;
    my $options = shift;
    my $ssl_opt = 1;
    if(defined($options) and defined($options->{ssl_verify_hostname})){
	$ssl_opt = $options->{ssl_verify_hostname};
    }
    my $mech = WWW::Mechanize->new(
	ssl_opts => {
	    verify_hostname => $ssl_opt
	   }
       );

    $mech->get($url) or die "$@\n";
    my $res = $mech->content();
    return $res;
}

sub post{
    my $self = shift;
    my $url = shift;
    my $params = shift;
    my $options = shift;
    my $ssl_opt = 1;
    if(defined($options) and defined($options->{ssl_verify_hostname})){
	$ssl_opt = $options->{ssl_verify_hostname};
    }
    my $mech = WWW::Mechanize->new(
	ssl_opts => {
	    verify_hostname => $ssl_opt
	   }
       );

    $mech->post($url,$params) or die "$@\n";
    my $res = $mech->content();
    return $res;
}

__PACKAGE__->meta->make_immutable();

1;
