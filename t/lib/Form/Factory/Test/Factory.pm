package FormFactory::Test::Factory;
use Test::Able::Role;
use Test::More;
use Test::Moose;

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has class_name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 1,
    default   => sub { 'FormFactory::Factory::' . shift->name },
);

has factory => (
    is        => 'ro',
    does      => 'FormFactory::Factory',
    required  => 1,
    default   => sub { FormFactory->new_factory('HTML') },
    lazy      => 1,
);

test plan => 4, factory_ok => sub { 
    my $self = shift;

    my $factory = $self->factory;
    ok($factory, "got a factory for " . $self->name);
    isa_ok($factory, $self->class_name);
    does_ok($factory, 'FormFactory::Factory');
    can_ok($factory, qw( render_control consume_control ));
};

1;
