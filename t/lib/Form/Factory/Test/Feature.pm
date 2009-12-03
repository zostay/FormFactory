package Form::Factory::Test::Feature;
use Test::Able::Role;

use Test::More;
use Test::Moose;

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
    lazy       => 1,
    default    => sub { 
        shift->interface->new_action('TestApp::Action::Featureful') 
    },
);

has feature => (
    is         => 'ro',
    does       => 'Form::Factory::Feature',
    required   => 1,
);

test plan => 2, basic_feature_checks => sub {
    my $self = shift;
    my $feature = $self->feature;

    does_ok($feature, 'Form::Factory::Feature');
    can_ok($feature, qw( clean check pre_process post_process ));
};

1;
