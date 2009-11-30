use strict;
use warnings;

use lib 't/lib';

use Form::Factory::Test;

my $test = Form::Factory::Test->new;
$test->run_tests;
