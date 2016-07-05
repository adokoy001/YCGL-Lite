package YCGL::Lite::Plack;
use strict;
use warnings;
use Safe;
use Mouse;
use Plack::Runner;
use Plack::App::File;
use Plack::Request;

sub plackup_static{
    my $self = shift;
    my $public_dir = shift;
    my $app = Plack::App::File->new(root => $public_dir)->to_app;
    my $runner = Plack::Runner->new;
    $runner->run($app);
}

sub plackup_eval {
    my $self = shift;
    my $path = shift;
    my $app = sub {
	my $env = shift;
	my $req = Plack::Request->new($env);
	my $response = {
	    $path => sub {
		my $json_req = $req->content //
		    return [400,['Content-Type' => 'text/plain'],['Content body required.']];
		my $perl_req = JSON::decode_json($json_req) //
		    return [400,['Content-Type' => 'text/plain'],['Valid JSON required']];
		my $data = $perl_req->{data};
		my $code_text = $perl_req->{code};
		my $code_ref;
		eval('$code_ref = sub '.$code_text.';');
		my $result = $code_ref->($data);
		return [200,['Content-Type' => 'application/json'],[JSON::encode_json({result => $result})]];
	    }
	   };
	if(defined($response->{$env->{PATH_INFO}})){
	    return $response->{$env->{PATH_INFO}}->();
	}else{
	    return [404,['Content-Type' => 'text/plain'],['Not Found']];
	}
    };
    my $runner = Plack::Runner->new;
    $runner->run($app);
}

__PACKAGE__->meta->make_immutable();

1;
