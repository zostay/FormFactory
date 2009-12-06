use strict;
use warnings;

use lib 't/lib';

use Form::Factory::Test;

my %args;
$args{test_packages} = [ 'Form::Factory::Test::' . $ENV{TEST_PACKAGE} ] 
    if $ENV{TEST_PACKAGE};

my $test = Form::Factory::Test->new(%args);
$test->run_tests;
