package YCGL::Lite::Parallel;
use strict;
use warnings;
use utf8;
use Mouse;
use Parallel::ForkManager;

sub do_with_result {
    my $self = shift;
    my $data = shift;
    my $code_ref = shift;
    my $max_proc = shift;
    my $result;
    my $pm = Parallel::ForkManager->new($max_proc);
    $pm->run_on_finish(
	sub {
	    my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure) = @_;
	    if (defined $data_structure) {
		$result->[$data_structure->{id}] = $data_structure->{result};
	    }
	}
       );
    for(my $k=0; $k <= $#$data; $k++){
	$pm->start and next;
	my $result_chil = $code_ref->($data->[$k]);
	my $result_with_id = {id => $k, result => $result_chil};
	$pm->finish(0,$result_with_id);
    }
    $pm->wait_all_children;
    return($result);
}

sub do_without_result {
    my $self = shift;
    my $data = shift;
    my $code_ref = shift;
    my $max_proc = shift;
    my $pm = Parallel::ForkManager->new($max_proc);
    for(my $k=0; $k <= $#$data; $k++){
	$pm->start and next;
	$code_ref->($data->[$k]);
	$pm->finish;
    }
    $pm->wait_all_children;
    return;
}

sub map_reduce {
    my $self = shift;
    my $data = shift;
    my $mapper_ref = shift;
    my $reducer_ref = shift;
    my $max_proc = shift;
    my $result;
    my $pm = Parallel::ForkManager->new($max_proc);
    $pm->run_on_finish(
	sub {
	    my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure) = @_;
	    if (defined $data_structure) {
		$result->[$data_structure->{id}] = $data_structure->{result};
	    }
	}
       );
    for(my $k=0; $k <= $#$data; $k++){
	$pm->start and next;
	my $result_chil = $mapper_ref->($data->[$k]);
	my $result_with_id = {id => $k, result => $result_chil};
	$pm->finish(0,$result_with_id);
    }
    $pm->wait_all_children;
    return($reducer_ref->($result));
}


__PACKAGE__->meta->make_immutable();

1;
