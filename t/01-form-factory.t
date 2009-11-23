use strict;
use warnings;

use Test::More tests => 3;
use Test::Moose;

require_ok('FormFactory');

my $factory = FormFactory->new_factory('HTML');
isa_ok($factory, 'FormFactory::Factory::HTML');
does_ok($factory, 'FormFactory::Factory');
