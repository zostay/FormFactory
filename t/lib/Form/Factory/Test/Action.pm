package FormFactory::Test::Action;
use Test::Able::Role;

has factory => (
    is         => 'ro',
    does       => 'FormFactory::Factory',
    required   => 1,
    lazy       => 1,
    default    => sub { FormFactory->new_factory('HTML') },
);

has action => (
    is         => 'ro',
    does       => 'FormFactory::Action',
    required   => 1,
);
1;
