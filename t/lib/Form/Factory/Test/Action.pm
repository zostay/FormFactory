package Form::Factory::Test::Action;
use Test::Able::Role;

has interface => (
    is         => 'ro',
    does       => 'Form::Factory::Interface',
    required   => 1,
    lazy       => 1,
    default    => sub { Form::Factory->new_interface('HTML') },
);

has action => (
    is         => 'ro',
    does       => 'Form::Factory::Action',
    required   => 1,
);
1;
