package FormFactory::Test::Action;
use Test::Able;
use Test::More;
use Test::Moose;

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

test plan => 1, meta_class => sub {
    my $self = shift;
    my $meta = $self->action->meta;

    does_ok($meta, 'FormFactory::Action::Meta::Class');
};

test plan => 3, meta_class_controls => sub {
    my $self     = shift;
    my @controls = $self->action->meta->get_controls;

    is(scalar @controls, 1, 'we have one control');
    does_ok($controls[0], 'FormFactory::Action::Meta::Attribute::Control');
    is($controls[0]->name, 'name', 'control is named name');
};

test plan => 3, meta_class_features => sub {
    my $self     = shift;
    my $features = $self->action->meta->features;

    ok($features, 'has features');
    is_deeply([ sort keys %{ $features } ], [ qw( functional ) ], 
        'has one feature');
    is_deeply([ sort keys %{ $features->{functional} } ],
        [ qw( checker_code cleaner_code post_processor_code pre_processor_code ) ],
        'functional feature has expected code keys');
};

test plan => 3, meta_class_all_features => sub {
    my $self = shift;
    my $features = $self->action->meta->get_all_features;

    ok($features, 'has features');
    is_deeply([ sort keys %{ $features } ], [ qw( functional ) ], 
        'has one feature');
    is_deeply([ sort keys %{ $features->{functional} } ],
        [ qw( checker_code cleaner_code post_processor_code pre_processor_code ) ],
        'functional feature has expected code keys');
};

test plan => 6, meta_control_name => sub {
    my $self = shift;
    my @controls = $self->action->meta->get_controls;
    my $control  = $controls[0];

    ok($control, 'got control');
    is($control->name, 'name', 'control is named name');
    is($control->placement, 0, 'control placement is 0');
    is($control->control, 'text', 'control control is text');
    is_deeply($control->options, {}, 'control options are empty');
    is_deeply($control->features, {}, 'control features are empty');
};

test plan => 13, control_name => sub {
    my $self = shift;
    my $control = $self->action->controls->{name};

    ok($control, 'got control');
    does_ok($control, 'FormFactory::Control');
    isa_ok($control, 'FormFactory::Control::Text');
    does_ok($control, 'FormFactory::Control::Role::Labeled');
    does_ok($control, 'FormFactory::Control::Role::ScalarValue');
    is($control->name, 'name', 'control is named name');
    is_deeply($control->features, [], 'control features are empty');
    is_deeply($control->stashable_keys, [ qw( value ) ], 
        'control value is stashable');
    is($control->has_value, '', 'control has no value');
    is($control->value, undef, 'control value is undef');
    is($control->has_default_value, '', 'control has no default value');
    is($control->default_value, undef, 'control default value is undef');
    is($control->current_value, '', 'control current value is the empty string');
};

1;
