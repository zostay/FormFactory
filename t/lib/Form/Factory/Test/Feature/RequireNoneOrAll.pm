package Form::Factory::Test::Feature::RequireNoneOrAll;
use Test::Able;

use Test::More;

with qw( Form::Factory::Test::Feature );

has '+action' => (
    default   => sub {
        shift->interface->new_action('TestApp::Action::RequireNoneOrAll')
    },
);

has '+feature' => (
    lazy      => 1,
    default   => sub {
        my $self = shift;
        (grep { $_->isa('Form::Factory::Feature::RequireNoneOrAll') }
            @{ $self->action->features })[0];
    },
);

sub error_message_is_ok {
    my ($self, $label) = @_;
    my $action = $self->action;

    my $errors = $action->results->error_messages;
    like($errors, qr/\b$label\b.*\b$label\b/, 
        "error has label $label in it twice");
}

test plan => 1, empty_input_is_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {} );
    $action->clean;
    $action->check;

    ok($action->results->is_valid, 'action is valid with none');
};

test plan => 1, group_one_all_input_is_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
    } );
    $action->clean;
    $action->check;

    ok($action->results->is_valid, 'action is valid with all one');
};

test plan => 1, all_all_input_is_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
        four  => 'qux',
        five  => 'quux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok($action->results->is_valid, 'action is valid with all all');
};

test plan => 2, one_incomplete_try_1_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one => 'foo',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with some one (1)');
    $self->error_message_is_ok('One');
};

test plan => 2, one_incomplete_try_2_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        two => 'foo',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with some one (2)');
    $self->error_message_is_ok('Two');
};

test plan => 2, one_incomplete_try_3_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        three => 'foo',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with some one (3)');
    $self->error_message_is_ok('Three');
};

test plan => 2, all_most_input_try_1_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        two   => 'bar',
        three => 'baz',
        four  => 'qux',
        five  => 'quux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (1)');
    $self->error_message_is_ok('Two');
};

test plan => 2, all_most_input_try_2_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        three => 'baz',
        four  => 'qux',
        five  => 'quux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (2)');
    $self->error_message_is_ok('One');
};

test plan => 2, all_most_input_try_3_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        four  => 'qux',
        five  => 'quux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (3)');
    $self->error_message_is_ok('Two');
};

test plan => 2, all_most_input_try_4_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
        five  => 'quux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (4)');
    $self->error_message_is_ok('Five');
};

test plan => 2, all_most_input_try_5_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
        four  => 'qux',
        six   => 'quuux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (5)');
    $self->error_message_is_ok('Four');
};

test plan => 2, all_most_input_try_6_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
        four  => 'qux',
        five  => 'quux',
        seven => 'quuuux',
    } );
    $action->clean;
    $action->check;

    ok(!$action->results->is_valid, 'action is invalid with all most (6)');
    $self->error_message_is_ok('Five');
};

test plan => 1, all_most_input_try_7_is_not_ok => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume( request => {
        one   => 'foo',
        two   => 'bar',
        three => 'baz',
        four  => 'qux',
        five  => 'quux',
        six   => 'quuux',
    } );
    $action->clean;
    $action->check;

    ok($action->results->is_valid, 'action is invalid with all most (7)');
};

1;
