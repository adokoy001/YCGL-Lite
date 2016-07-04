package YCGL::Lite::DataConverter;
use strict;
use warnings;
use utf8;
use Mouse;
use JSON;
use Text::CSV;
use XML::Simple;
use Data::MessagePack;


sub perl_to_json {
    my $self = shift;
    my $data = shift;
    my $json_text = JSON::encode_json $data;
    return($json_text);
}

sub json_to_perl {
    my $self = shift;
    my $json = shift;
    my $perl_data = JSON::decode_json $json;
    return($perl_data);
}

sub perl_to_csv {
    my $self = shift;
    my $data = shift;
    my $options = shift;
    my $EOL = "\n";
    if(defined($options) and defined($options->{eol})){
	$EOL = $options->{eol};
    }
    my $csv = Text::CSV->new({binary => 1});
    $csv->eol($EOL);
    my $serialized = '';
    open my $fh, '>', \$serialized;
    for(my $k=0; $k <= $#$data; $k++){
	$csv->print($fh,$data->[$k]);
    }
    close($fh);
    return($serialized);
}

sub csv_to_perl {
    my $self = shift;
    my $text = shift;
    my $csv = Text::CSV->new({binary => 1});
    open my $fh, '<', \$text;
    my $rows = $csv->getline_all($fh);
    close($fh);
    return($rows);
}

sub csvfile_to_perl {
    my $self = shift;
    my $file = shift;
    my $csv = Text::CSV->new({binary => 1});
    open my $fh, '<', $file;
    my $rows = $csv->getline_all($fh);
    close($fh);
    return($rows);
}

sub perl_to_csvfile {
    my $self = shift;
    my $data = shift;
    my $filename = shift;
    my $options = shift;
    my $EOL = "\n";
    if(defined($options) and defined($options->{eol})){
	$EOL = $options->{eol};
    }
    my $csv = Text::CSV->new({binary => 1});
    $csv->eol($EOL);
    open my $fh, '>', $filename;
    for(my $k=0; $k <= $#$data; $k++){
	$csv->print($fh,$data->[$k]);
    }
    close($fh);
}

sub perl_to_xml {
    my $self = shift;
    my $records = shift;
    my $options = shift;
    my $xml = XML::Simple->new(
	ForceArray => $options->{ForceArray},
	RootName => $options->{RootName},
	XMLDecl => $options->{XMLDecl}
       );
    my $xml_out = $xml->XMLout($records);
    return($xml_out);
}

sub xml_to_perl {
    my $self = shift;
    my $xml_text = shift;
    my $options = shift;
    my $xml = XML::Simple->new(
	ForceArray => $options->{ForceArray},
	RootName => $options->{RootName},
	XMLDecl => $options->{XMLDecl}
       );
    my $perl_from_xml = $xml->XMLin($xml_text);
    return($perl_from_xml);
}

sub perl_to_msgpack {
    my $self = shift;
    my $data = shift;
    my $msgpack = Data::MessagePack->new();
    my $packed = $msgpack->pack($data);
    return($packed);
}

sub msgpack_to_perl {
    my $self = shift;
    my $msg_text = shift;
    my $msgpack = Data::MessagePack->new();
    my $unpacked = $msgpack->unpack($msg_text);
    return($unpacked);
}

__PACKAGE__->meta->make_immutable();

1;
