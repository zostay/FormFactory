use strict;
use warnings;

use lib 't/lib';

use FormFactory::Test;

my $test = FormFactory::Test->new;
$test->run_tests;
