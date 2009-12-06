package Form::Factory::Test::Action::Inheritance;
use Test::Able;
use Test::More;
use Test::Moose;

with qw( Form::Factory::Test::Action );

has '+action' => (
    lazy      => 1,
    default   => sub {
        shift->interface->new_action('TestApp::Action::Bottom');
    },
);

test plan => 1, run_action => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume_and_clean_and_check_and_process( request => {} );

    ok($action->is_success, 'action runs');
};

test plan => 5, inherited_checks => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume_and_clean_and_check_and_process( request => {
        foo => 'Aa1',
    });

    ok(!$action->is_valid, 'action does not validate');
    
    my @errors = sort $action->results->regular_error_messages;
    is(scalar @errors, 3, 'got three errors');

    like($errors[0]->message, qr/lowercase letters/, 'got lowercase letters error');
    like($errors[1]->message, qr/numbers/, 'got numbers error');
    like($errors[2]->message, qr/uppercase letters/, 'got uppsercase letters error');
};

1;
