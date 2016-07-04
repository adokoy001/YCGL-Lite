package YCGL::Lite::Times;
use strict;
use warnings;
use Time::HiRes;
use Date::Calc;
use Mouse;

has 'internal_timer' => ( is => 'rw', isa => 'Num', default => 0);

sub timer_start {
    my $self = shift;
    my $current_time = Time::HiRes::time;
    $self->internal_timer($current_time);
};

sub timer_elapsed {
    my $self = shift;
    my $diff = Time::HiRes::time - $self->internal_timer;
    return($diff);
};

sub timer_reset {
    my $self = shift;
    $self->internal_timer(0);
}

# get today date style
sub today{
    my $self = shift;
    my ($date_year,$date_month,$date_day) = Date::Calc::Today();
    my $date_result = sprintf(
	"%04d-%02d-%02d",
	$date_year,
	$date_month,
	$date_day
       );
    return($date_result);
}

# get current timestamp
sub current_timestamp{
    my $self = shift;
    my ($date_year,$date_month,$date_day,$date_hour,$date_min,$date_sec) = Date::Calc::Today_and_Now();
    my $date_result = sprintf(
	"%04d-%02d-%02d %02d:%02d:%02d",
	$date_year,
	$date_month,
	$date_day,
	$date_hour,
	$date_min,
	$date_sec
       );
    return($date_result);
}

sub date_add{
    my $self = shift;
    my $date = shift;
    my $diff_year = shift;
    my $diff_month = shift;
    my $diff_day = shift;
    my ($date_year,$date_month,$date_day) = _split_date($date);
    my @date_result_array = Date::Calc::Add_Delta_YMD(
	$date_year, $date_month, $date_day,
	$diff_year, $diff_month, $diff_day);
    my $date_result = sprintf(
	"%04d-%02d-%02d",
	$date_result_array[0],
	$date_result_array[1],
	$date_result_array[2]
       );
    return($date_result);
}

sub date_diff{
    my $self = shift;
    my $date_1 = shift;
    my $date_2 = shift;
    my ($date_year_1,$date_month_1,$date_day_1) = _split_date($date_1);
    my ($date_year_2,$date_month_2,$date_day_2) = _split_date($date_2);
    my $diff = Date::Calc::Delta_Days(
	$date_year_1,$date_month_1,$date_day_1,
	$date_year_2,$date_month_2,$date_day_2
       );
    return($diff);
}

sub split_date {
    my $self = shift;
    my $date = shift;
    my ($date_year,$date_month,$date_day);
    if($date =~ /([0-9]{4})[\-\/]{0,1}([0-9]{2})[\-\/]{0,1}([0-9]{2})/){
	$date_year = $1;
	$date_month = $2;
	$date_day = $3;
    }
    return($date_year,$date_month,$date_day);
}

sub split_timestamp {
    my $self = shift;
    my $timestamp = shift;
    my ($date_year,$date_month,$date_day,$hour,$min,$sec);
    if($timestamp =~ /([0-9]{4})[\-\/]{0,1}([0-9]{2})[\-\/]{0,1}([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/){
	$date_year = $1;
	$date_month = $2;
	$date_day = $3;
	$hour = $4;
	$min = $5;
	$sec = $6;
    }
    return($date_year,$date_month,$date_day,$hour,$min,$sec);
}


# internal function
sub _split_date {
    my $date = shift;
    my ($date_year,$date_month,$date_day);
    if($date =~ /([0-9]{4})[\-\/]{0,1}([0-9]{2})[\-\/]{0,1}([0-9]{2})/){
	$date_year = $1;
	$date_month = $2;
	$date_day = $3;
    }
    return($date_year,$date_month,$date_day);
}

__PACKAGE__->meta->make_immutable();

1;
