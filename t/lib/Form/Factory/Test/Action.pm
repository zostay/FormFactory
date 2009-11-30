package Form::Factory::Test::Action;
use Test::Able::Role;

has factory => (
    is         => 'ro',
    does       => 'Form::Factory::Factory',
    required   => 1,
    lazy       => 1,
    default    => sub { Form::Factory->new_factory('HTML') },
);

has action => (
    is         => 'ro',
    does       => 'Form::Factory::Action',
    required   => 1,
);
1;
