use strict;
use warnings;

use Test::More tests => 5;
use Test::Moose;

require_ok('FormFactory');

my %factories = (
    HTML => {},
);

sub factory_ok($$) {
    my ($name, $options) = @_;

    my $factory = FormFactory->new_factory('HTML');
    ok($factory, "got a factory for $name");
    isa_ok($factory, 'FormFactory::Factory::' . $name);
    does_ok($factory, 'FormFactory::Factory');
    can_ok($factory, qw( render_control consume_control ));
}

while (my ($name, $options) = each %factories) {
    factory_ok($name, $options);
}
