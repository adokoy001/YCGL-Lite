requires 'perl', '5.008001';
requires 'Mouse', '0';
requires 'Time::HiRes', '0';
requires 'Date::Calc', '0';
requires 'WWW::Mechanize', '0';
requires 'LWP::Protocol::https', '0';
requires 'Net::SMTP', '0';
requires 'Parallel::ForkManager', '0';
requires 'JSON', '0';
requires 'Text::CSV', '0';
requires 'XML::Simple', '0';
requires 'Data::MessagePack', '0';
requires 'Plack', '0';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

