package FormFactory::Action;
use Moose::Role;

use FormFactory::Feature::Functional;
use FormFactory::Result::Gathered;
use FormFactory::Result::Single;
use FormFactory::Util qw( class_name_from_name );

#requires qw( run );

has form_factory => (
    is        => 'ro',
    does      => 'FormFactory::Factory',
    required  => 1,
);

has globals => (
    is        => 'ro',
    isa       => 'HashRef[Str]',
    required  => 1,
    default   => sub { {} },
);

has results => (
    is        => 'rw',
    isa       => 'FormFactory::Result',
    required  => 1,
    lazy      => 1,
    default   => sub { FormFactory::Result::Gathered->new },
    handles   => [ qw(
        is_valid is_success is_failure

        messages field_messages
        info_messages warning_messages error_messages
        field_info_messages field_warning_messages field_error_messages
    ) ],
);

has result => (
    is        => 'rw',
    isa       => 'FormFactory::Result',
    required  => 1,
    lazy      => 1,
    default   => sub { FormFactory::Result::Single->new },
);

has features => (
    is          => 'ro',
    isa         => 'ArrayRef',
    required    => 1,
    lazy        => 1,
    initializer => '_init_features',
    default     => sub { [] },
);

sub _meta_features {
    my $self = shift;

    my @features;
    for my $feature_config (@{ $self->meta->get_all_features }) {
        my $feature = FormFactory::Feature::Functional->new(
            %$feature_config,
            action => $self,
        );
        push @features, $feature;
    }

    return \@features;
}

sub _init_features {
    my ($self, $features, $set, $attr) = @_;
    push @$features, @{ $self->_meta_features };
    $set->($features);
}

has controls => (
    is        => 'ro',
    isa       => 'HashRef',
    required  => 1,
    lazy      => 1,
    builder   => '_build_controls',
);

sub _build_controls {
    my $self = shift;
    my $factory  = $self->form_factory;
    my $features = $self->features;

    my %controls;
    my @meta_controls = $self->meta->get_controls;
    for my $meta_control (@meta_controls) {
        my %options = %{ $meta_control->options };
        for my $key (keys %options) {
            my $value = $options{$key};

            next unless blessed $value;
            next unless $value->isa('FormFactory::Processor::DeferredValue');

            $options{$key} = $value->code->($self, $key);
        }

        my $control = $factory->new_control($meta_control->control => {
            name => $meta_control->name,
            %options,
        });

        my $meta_features = $meta_control->features;
        for my $feature_name (keys %$meta_features) {
            my $feature_class = 'FormFactory::Feature::Control::' 
                              . class_name_from_name($feature_name);
            Class::MOP::load_class($feature_class);

            my $feature = $feature_class->new(
                %{ $meta_features->{$feature_name} },
                action  => $self,
                control => $control,
            );
            push @$features, $feature;
            push @{ $control->features }, $feature;
        }

        $controls{ $meta_control->name } = $control;
    }

    return \%controls;
}

sub stash {
    my ($self, $moniker) = @_;

    my $controls = $self->controls;
    my %controls;
    for my $control_name (keys %$controls) {
        my $control = $controls->{ $control_name };

        my $keys = $control->stashable_keys;
        for my $key (@$keys) {
            $controls{$control_name}{$key} = $control->$key;
        }
    }

    my %stash = (
        globals  => $self->globals,
        controls => \%controls,
        results  => $self->results,
        result   => $self->result,
    );

    $self->form_factory->stash($moniker => \%stash);
}

sub unstash {
    my ($self, $moniker) = @_;

    my $stash = $self->form_factory->unstash($moniker);
    return unless defined $stash;

    my $globals = $stash->{globals} || {};
    for my $key (keys %$globals) {
        $self->globals->{$key} = $globals->{$key};
    }

    my $controls       = $self->controls;
    my $controls_state = $stash->{controls} || {};
    for my $control_name (keys %$controls) {
        my $state   = $controls_state->{$control_name};
        my $control = $controls->{$control_name};
        my $keys    = $control->stashable_keys;
        for my $key (@$keys) {
            next unless exists $state->{$key};
            eval { $control->$key($state->{$key}) };
            #warn "unstash partially failed: $@" if $@;
        }
    }

    $self->results($stash->{results} || FormFactory::Result::Gathered->new);
    $self->result($stash->{result} || FormFactory::Result::Single->new);
}

sub clear {
    my ($self) = @_;

    %{ $self->globals } = ();

    my $controls       = $self->controls;
    for my $control_name (keys %$controls) {
        my $control = $controls->{ $control_name };
        my $keys    = $control->stashable_keys;
        for my $key (@$keys) {
            delete $control->{$key}; # ugly
        }
    }

    $self->results->clear_messages;
    $self->results->clear_results;
    $self->result(FormFactory::Result::Single->new);
}

sub render {
    my $self = shift;
    my %params = @_;
    my @names  = defined $params{controls} ?    @{ delete $params{controls} } 
               :                             map { $_->name } 
                                                   $self->meta->get_controls
               ;

    $params{results} = $self->results;

    my $controls = $self->controls;
    $self->form_factory->render_control($controls->{$_}, %params) for @names;
    return;
}

sub render_control {
    my ($self, $name, $options, %params) = @_;

    $params{results} = $self->results;

    $self->form_factory->render_control(
        $self->form_factory->new_control($name => $options), %params
    );
}

sub consume {
    my $self   = shift;
    my %params = @_;
    my @names  = defined $params{controls} ?    @{ delete $params{controls} } 
               :                             map { $_->name } 
                                                   $self->meta->get_controls
               ;

    my $controls = $self->controls;
    $self->form_factory->consume_control($controls->{$_}, %params) for @names;
}

sub _run_features {
    my $self     = shift;
    my $method   = shift;
    my %params   = @_;
    my $features = $self->features;

    # Only run the requested control-specific features
    if (defined $params{controls}) {
        my %names = map { $_ => 1 } @{ $params{controls} };

        for my $feature (@$features) {
            next unless $feature->does('FormFactory::Feature::Role::Control');
            next unless $names{ $feature->control->name };

            $feature->$method;
        }
    }

    # Run all features now
    else {
        for my $feature (@$features) {
            $feature->$method;
        }
    }
}

sub clean {
    my $self = shift;
    $self->_run_features(clean => @_);
}

sub check {
    my $self = shift;
    $self->_run_features(check => @_);

    $self->gather_results;

    my @errors = $self->error_messages;
    $self->result->is_valid(@errors == 0);
}

sub set_attributes_from_controls {
    my $self = shift;
    my $meta = $self->meta;

    my $controls = $self->controls;
    while (my ($name, $control) = each %$controls) {
        my $attribute = $meta->find_attribute_by_name($name);
        die "attribute for control $name not found on $self" 
            unless defined $attribute;
        $control->set_attribute_value($self, $attribute);
    }
}

sub process {
    my $self = shift;
    return unless $self->is_valid;

    $self->set_attributes_from_controls;

    $self->_run_features('pre_process');
    $self->run;
    $self->_run_features('post_process');

    $self->gather_results;

    my @errors = $self->error_messages;
    $self->result->is_success(@errors == 0);
}

sub consume_and_clean_and_check_and_process {
    my $self = shift;
    $self->consume(@_);
    $self->clean;
    $self->check;
    $self->process;
}

sub gather_results {
    my $self = shift;
    my $controls = $self->controls;
    $self->results->gather_results( 
        $self->result, 
        map { $_->result } @{ $self->features } 
    );
}

1;
