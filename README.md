# NAME

YCGL::Lite - Yokoda Common General Library lite.

# SYNOPSIS

    use strict;
    use warnings;
    use feature qw(say);
    use YCGL::Lite;

    my $ycgl = YCGL::Lite->new();

    ## Current timestamp
    my $current_timestamp = $ycgl->times->current_timestamp();
    say $current_timestamp; # 2016-01-01 00:00:00
    my $today = $ycgl->times->today();
    say $today; # 2016-01-01

    my $date_one_month_ago = $ycgl->times->date_add($today,0,-1,0);
    say $date_one_month_ago; # 2015-12-01
    my $date_diff = $ycgl->times->date_diff($today,'2016-01-05');
    say $date_diff; # 4

    ## Mail
    my $mail_data = {
       to => [{name => 'to1',addr =>'to1@example.com'}],
       cc => [{name => 'cc1', addr => 'cc1@example.com'}],
       bcc => [{name => 'bcc', addr => 'bcc1@example.com'}],
       from => {name => 'myname', addr => 'myname@example.com'},
       mta_addr => '127.0.0.1',
       subject => 'mail example.',
       content => 'This is example.',
       content_type => 'text/plain'
    };

    $ycgl->mail->send_mail($mail_data);

    ## HTTP, HTTPS client
    my $result_http = $ycgl->http_client->get('http://example.com');
    my $result_https = $ycgl->http_client->post('https://example.com',{username => 'myname', password => 'password'});

    ## Data interchange
    # JSON
    my $json_text = $ycgl->data_conv->perl_to_json({name => 'myname', age => 20});
    my $perl_from_json = $ycgl->data_conv->json_to_perl($json_text);

    # CSV
    my $csv_text = $ycgl->data_conv->perl_to_csv([['name','age'],['myname',20],['yourname',21]]);
    my $perl_from_csv = $ycgl->data_conv->csv_to_perl($csv_text);
    my $perl_from_csvfile = $ycgl->data_conv->csvfile_to_perl('./mycsvfile.csv');
    $ycgl->data_conv->perl_to_csvfile($perl_from_csvfile,'./mycsvoutput.csv');

    # XML
    my $xml_records = {
      meta_data => [{source_name => ['MYSOURCE']}],
      records =>
      [
        {
          data_seq => 1,
          pname => 'myname',
          age => 20
        },
        {
          data_seq => 2,
          pname => 'yourname',
          age => 21
        }
      ]
    };
    my $xml_text = $ycgl->data_conv->perl_to_xml(
      $xml_records,
      {ForceArray => 1,RootName => 'ROOTNAME', XMLDecl => 1} # option
    );
    my $perl_from_xml = $ycgl->data_conv->xml_to_perl($xml_text);

    # YAML
    my $yaml_text = $ycgl->data_conv->perl_to_yaml({name => 'myname', age => 20});
    my $perl_from_yaml = $ycgl->data_conv->yaml_to_perl($yaml_text);

    # MessagePack
    my $msgpack_text = $ycgl->data_conv->perl_to_msgpack({name => 'myname', age => 20});
    my $perl_from_msgpack = $ycgl->data_conv->msgpack_to_perl($msgpack_text);

    ## Parallel Processing
    my $data_parallel_1 = [{val_1 => 1, val_2 => 2},{val_1 => 10, val_2 => 20}];
    my $my_sub_1 = sub {my $inputs = shift; return($inputs{val_1} + $inputs{val_2});};
    my @results = $ycgl->parallel->do_with_result($data_parallel_1, $my_sub_1, 10);

    my $data_parallel_2 = ['http://example.com/1','http://example.com/2'];
    my $my_sub_2 = sub {my $url = shift; $ycgl->http_client->get($url);};
    $ycgl->parallel->do_without_result($data_parallel_2, $my_sub_2, 20);

    ## Plack Server
    my $responses = {
        '/' => sub { return [500, ['Content-Type' => 'text/plain'],['Hello, World!']]; }
    };
    my $public_dir = './public/';
    $ycgl->plack->plackup_app($responses,$public_dir);

    $ycgl->plack->plackup_static($public_dir);

# DESCRIPTION

YCGL::Lite has commonly and generally used functions.

# LICENSE

Copyright (C) Toshiaki Yokoda.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Toshiaki Yokoda <adokoy001@gmail.com>
