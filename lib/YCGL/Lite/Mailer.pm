package YCGL::Lite::Mailer;
use strict;
use warnings;
use utf8;
use Mouse;
use Encode qw(from_to encode);
use Net::SMTP;


sub send_mail{
    my $self = shift;
    my $mail_config = shift;
    my $mail_list_ref = $mail_config->{to};
    my $from_addr = $mail_config->{from};
    my $subject = $mail_config->{subject};
    my $content = $mail_config->{content};
    my $mta_addr = $mail_config->{mta_addr};
    my $content_type = $mail_config->{content_type};
    my $mail_list_ref_cc = $mail_config->{cc};
    my $mail_list_ref_bcc = $mail_config->{bcc};
    my $data_list_ref = $mail_config->{data};

    unless(defined($content_type) and ($content_type ne '')){
	$content_type = 'text/plain';
    }

    # to送信リスト作成
    my @mail_list;
    for(0 .. $#$mail_list_ref){
	my $tmp_to = '"'.$mail_list_ref->[$_]->{name}
	    .'" <'.$mail_list_ref->[$_]->{addr}.'>';
	push(@mail_list,$tmp_to);
    }

    ## 添付ファイル作成
    # boundaryランダム生成
    my @rand_chars = (0..9,'a'..'z','A'..'Z');
    my $bound = '';
    for(1 .. 32){$bound .= $rand_chars[rand($#rand_chars)]};
    # ヘッダ生成
    my $mime_header = '';
    my $attachment = '';
    if(defined($data_list_ref) and ($data_list_ref ne '')){
	$mime_header = "MIME-Version: 1.0\nContent-Type: multipart/mixed; boundary=\"$bound\"\n"
	    ."Content-Transfer-Encoding: Base64\n";
    }

    # 送信データ作成
    my $header_mailfrom = '"'.$from_addr->{name}.'" <'.$from_addr->{addr}.'>';
    my $mailto = join(',',@mail_list);

    encode('utf8',$mailto);
    encode('utf8',$header_mailfrom);
    encode('utf8',$content);
    encode('utf8',$subject);
    # メール本文ヘッダー生成
    my $header_from_addr = '';
    if(defined($from_addr) and ($from_addr ne '')){
	$header_from_addr = "From: $header_mailfrom\n";
    }
    my $header_subject = '';
    if(defined($subject) and ($subject ne '')){
	$header_subject = "Subject: $subject\n";
    }
    my $header_to_addr = '';
    if(defined($mail_list_ref) and ($mail_list_ref ne '')){
	$header_to_addr = "To: $mailto\n";
    }

    # cc送信リスト作成
    my @mail_list_cc;
    my $mailcc = '';
    if(defined($mail_list_ref_cc) and ($mail_list_ref_cc ne '')){
	for(0 .. $#$mail_list_ref_cc){
	    my $tmp_to = '"'.$mail_list_ref_cc->[$_]->{name}
		.'" <'.$mail_list_ref_cc->[$_]->{addr}.'>';
	    push(@mail_list_cc,$tmp_to);
	}
	$mailcc = "Cc: ".join(',',@mail_list_cc)."\n";
	encode('utf8',$mailcc);
    }

    # bcc送信リスト作成
    my @mail_list_bcc;
    my $mailbcc = '';
    if(defined($mail_list_ref_bcc) and ($mail_list_ref_bcc ne '')){
	for(0 .. $#$mail_list_ref_bcc){
	    my $tmp_to = '"'.$mail_list_ref_bcc->[$_]->{name}
		.'" <'.$mail_list_ref_bcc->[$_]->{addr}.'>';
	    push(@mail_list_bcc,$tmp_to);
	}
	$mailbcc = "Bcc: ".join(',',@mail_list_bcc)."\n";
	encode('utf8',$mailbcc);
    }

    my $smtp = Net::SMTP->new($mta_addr);
    my $mail_head =
	$mime_header.
	$header_from_addr.
	$header_to_addr.
	$mailcc.
	$mailbcc.
	$header_subject.
	"Mime-Version: 1.0\n";
    if(defined($data_list_ref)){
	$mail_head .= "--$bound\n";
    }
    $mail_head .= "Content-Type: $content_type; charset=\"UTF-8\"\n\n";
    $smtp->mail($from_addr->{addr});
    $smtp->to(@mail_list);
    if(defined($mail_list_ref_cc)){$smtp->cc(@mail_list_cc)}
    if(defined($mail_list_ref_bcc)){$smtp->cc(@mail_list_bcc)}
    $smtp->data();
    $smtp->datasend($mail_head);
    $smtp->datasend($content);
    if(defined($data_list_ref)){
	for(0 .. $#$data_list_ref){
	    my $attache_filename = $data_list_ref->[$_]->{filename};
	    encode('utf8',$attache_filename);
	    $smtp->datasend("\n");
	    $smtp->datasend("--$bound\n");
	    $smtp->datasend("Content-Transfer-Encoding: Base64\n");
	    $smtp->datasend("Content-Type: application/octet-stream\n");
	    $smtp->datasend("Content-Disposition: attachment; filename=\"$attache_filename\"\n\n");
	    $smtp->datasend($data_list_ref->[$_]->{data}."\n");
	}
	$smtp->datasend("--$bound--\n");
    }
    $smtp->datasend();
    $smtp->quit;
}

__PACKAGE__->meta->make_immutable();

1;
