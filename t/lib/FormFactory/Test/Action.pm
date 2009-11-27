package FormFactory::Test::Action;
use Test::Able;
use Test::More;

has factory => (
    is         => 'ro',
    does       => 'FormFactory::Factory',
    required   => 1,
    default    => sub { FormFactory->new_factory('HTML') },
    lazy       => 1,
);

has action => (
    is         => 'ro',
    does       => 'FormFactory::Action',
    required   => 1,
    default    => sub { shift->factory->new_action('TestApp::Action::Basic') },
    lazy       => 1,
);

test plan => 5, run_action => sub {
    my $self = shift;
    my $action = $self->action;

    $action->consume_and_clean_and_check_and_process( request => {} );

    is($action->content->{one}, 1, 'clean is first');
    is($action->content->{two}, 2, 'check is second');
    is($action->content->{three}, 3, 'pre_process is third');
    is($action->content->{four}, 4, 'run is fourth');
    is($action->content->{five}, 5, 'post_process is fifth');
};


1;
