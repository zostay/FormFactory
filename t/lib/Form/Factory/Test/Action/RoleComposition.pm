package Form::Factory::Test::Action::RoleComposition;
use Test::Able;
use Test::More;
use Test::Moose;

with qw( Form::Factory::Test::Action );

use TestApp::Action::Composed;

has '+action' => (
    lazy      => 1,
    default   => sub {
        shift->interface->new_action('TestApp::Action::Composed');
    },
);

test plan => 2, run_action => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume_and_clean_and_check_and_process( request => {
        part_one => 'foo',
        part_two => 'bar',
    });

    ok($action->is_success, 'action runs');
    is($action->result->content->{something}, 'oof,rab', 'features running');
};

1;
