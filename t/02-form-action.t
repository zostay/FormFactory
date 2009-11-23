use strict;
use warnings;

use lib 't/lib';

use Test::More tests => 6;
use Test::Moose;

require_ok('FormFactory');

my $factory = FormFactory->new_factory('HTML');
my $action = $factory->new_action('TestApp::Action::Basic');

$action->consume_and_clean_and_check_and_process( request => {} );

is($action->content->{one}, 1, 'clean is first');
is($action->content->{two}, 2, 'check is second');
is($action->content->{three}, 3, 'pre_process is third');
is($action->content->{four}, 4, 'run is fourth');
is($action->content->{five}, 5, 'post_process is fifth');
