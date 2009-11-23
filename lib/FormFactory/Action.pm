package FormFactory::Action;
use Moose::Role;

use FormFactory::Feature::Functional;
use FormFactory::Result::Gathered;
use FormFactory::Result::Single;
use FormFactory::Util qw( class_name_from_name );

#requires qw( run );

=head1 NAME

FormFactory::Action - Role implemented by actions

=head2 SYNOPSIS

  package MyApp::Action::Foo;
  use FormFactory::Processor;

  has_control bar => (
      type => 'text',
  );

  sub run {
      my $self = shift;

      # Do something...
  }

=head1 DESCRIPTION

This is the role implemented by all form actions.

=head1 ATTRIBUTES

All form actions have the following attributes.

=head2 form_factory

This is the L<FormFactory::Factory> that constructed this action. If you need to get at the implementation directly for some reason, here it is. This is mostly used by the action itself when calling the L</render> and L</consume> methods.

=cut

has form_factory => (
    is        => 'ro',
    does      => 'FormFactory::Factory',
    required  => 1,
);

=head2 globals

This is a hash of extra parameters to keep with the form. Normally, these are saved with a call to L</stash> and recovered with a call to L</unstash>.

=cut

has globals => (
    is        => 'ro',
    isa       => 'HashRef[Str]',
    required  => 1,
    default   => sub { {} },
);

=head2 results

This is a L<FormFactory::Result::Gathered> object that tracks the general success, failure, messages, and output from the execution of this action.

Actions delegate a number of methods to this object. See L</RESULTS>.

=cut

has results => (
    is        => 'rw',
    isa       => 'FormFactory::Result',
    required  => 1,
    lazy      => 1,
    default   => sub { FormFactory::Result::Gathered->new },
    handles   => [ qw(
        is_valid is_success is_failure
        is_validated is_outcome_known

        all_messages regular_messages field_messages
        info_messages warning_messages error_messages
        regular_info_messages regular_warning_messages regular_error_messages
        field_info_messages field_warning_messages field_error_messages

        content
    ) ],
);

=head2 result

This is a L<FormFactory::Result::Single> used to record general outcome.

Actions delegate a number of methods to this object. See L</RESULTS>.

=cut

has result => (
    is        => 'rw',
    isa       => 'FormFactory::Result::Single',
    required  => 1,
    lazy      => 1,
    default   => sub { FormFactory::Result::Single->new },
    handles   => [ qw(
        success failure

        add_message
        info warning error
        field_info field_warning field_error
    ) ],
);

=head2 features

This is a list of L<FormFactory::Feature> objects used to modify the object. This will always contain the features that are attached to the class itself. Additional features may be added here.

=cut

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

=head2 controls

This is a hash of controls attached to this action. For every C<has_control> line in the action class, there should be a matching control in this hash.

=cut

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

=head1 METHODS

=head2 stash

  $action->stash($moniker);

Given a C<$moniker> (a key under which to store the information related to this form), this will stash the form's stashable information under that name using the L<FormFactory::Stasher> associated with the L</form_factory>.

The globals, stashable parts of controls, and the results are stashed. This allows those values to be recovered across requests or between process calls or whatever the implementation requires.

=cut

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

=head2 unstash

  $action->unstash($moniker);

Given a C<$moniker> previously named in a call to L</stash>, it restores the previously stashed state. This is a no-op if nothing is stashed under this moniker.

=cut

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

=head2 clear

This method clears the stashable state of the action.

=cut

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

=head2 render

  $action->render(%options);

Renders the form using the associated L</form_factory>. You may specify the following options:

=over

=item controls

This is a list of control names to render. If not given, all controls will be rendered.

=back

Any other options will be passed on to the L<FormFactory::Factory/render_control> method.

=cut

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

=head2 render_control

  $action->render_control($name, \%options);

Creates and renders a one time control. This is mostly useful for attaching buttons to a form. The control is not added to the list of controls on the action and will not be processed later.

=cut

sub render_control {
    my ($self, $name, $options, %params) = @_;

    $params{results} = $self->results;

    $self->form_factory->render_control(
        $self->form_factory->new_control($name => $options), %params
    );
}

=head2 consume

  $action->consume(%options);

This consumes any input from user and places it into the controls of the form. You may pass the following options:

=over

=item controls

This is a list of names of controls to consume. Any not listed here will not be consumed. If this option is missing, all control values are consumed.

=back

Any additional options will be passed to the L<FormFactory::Factory/consume_control> method call.

=cut

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

=head2 clean

  $action->clean(%options);

Takes the values consumed from the user and cleans them up. For example, if you allow users to type in a phone number, this can be used to clear out any unwanted or incorrect punctuation and format the phone number properly.

This method runs through all the requested L<FormFactory::Feature> objects in L</features> and runs the L<FormFactory::Feature/clean> method for each.

The following options are used:

=over

=item controls

This is the list of controls to clean. If not given, all features will be run. If given, only the control-features (those implementing L<FormFactory::Feature::Role::Control> attached to the named controls) will be run. Any form-features or unlisted control-features will not be run.

=back

=cut

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

=head2 check

  $action->check(%options);

The C<check> method is responsible for verifying the correctness of the input. It assumes that L</clean> has already run.

It runs the L<FormFactory::Feature/check> method of all the selected L</features> attached to the action. It also sets the C<is_valid> flag to true if no errors have been recored yet or to false if they have.

The following options are used:

=over

=item controls

This is the list of controls to check. If not given, all features will be run. If given, only the control-features (those implementing L<FormFactory::Feature::Role::Control> attached to the named controls) will be run. Any form-features or unlisted control-features will not be run.

=back

=cut

sub check {
    my $self = shift;
    $self->_run_features(check => @_);

    $self->gather_results;

    my @errors = $self->error_messages;
    $self->result->is_valid(@errors == 0);
}

=head2 process

  $action->process;

This does nothing if the action did not validate.

In the case the action is valid, this will use L</set_attributes_from_controls> to copy the control values to the action attributes, run the L<FormFactory::Feature/pre_process> methods for all form-features and control-features, call the L</run> method, run the L<FormFactory::Feature/post_process> methods for all form-features and control-features, and set the C<is_success> flag to true if no errors are recorded or false if there are.

=cut

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

=head2 consume_and_clean_and_check_and_process

This is a shortcut for taking all the usual workflow actions in a single call:

  $action->consume(@_);
  $action->clean;
  $action->check
  $action->process;

=cut

sub consume_and_clean_and_check_and_process {
    my $self = shift;
    $self->consume(@_);
    $self->clean;
    $self->check;
    $self->process;
}

=head1 ROLE METHODS

This method must be implemented by any action implementation.

=head2 run

This is the method that actually does the work. It takes no arguments and is expected to return nothing. You should draw your input from the action attributes (not the controls) and report your results to L</result>.

=head1 HELPER METHODS

These methods are primarily intended for internal use.

=head2 set_attributes_from_controls

This method is used by L</process> to copy the values out of the controls into the form action attributes. This assumes that such a copy will work because the L</clean> and L</check> phases should have already run and passed without error.

=cut

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

=head2 gather_results

Gathers results for all the associated L</controls> and L</result> into L</results>. This is called just before deciding if the action has validated correctly or if the action has succeeded.

=cut

sub gather_results {
    my $self = shift;
    my $controls = $self->controls;
    $self->results->gather_results( 
        $self->result, 
        map { $_->result } @{ $self->features } 
    );
}

=head1 RESULTS

Actions are tied closely to L<FormFactory::Result>s. As such, a number of methods are delegated to result classes.

The following methods are delegated to L</results> in L<FormFactory::Result::Gathered>.

=over

=item is_valid

=item is_success

=item is_failure

=item is_validated 

=item is_outcome_known

=item all_messages 

=item regular_messages

=item field_messages

=item info_messages 

=item warning_messages 

=item error_messages

=item regular_info_messages 

=item regular_warning_messages 

=item regular_error_messages

=item field_info_messages 

=item field_warning_messages 

=item field_error_messages

=item content

=back

These methods are delegated to L<result> in L<FormFactory::Result::Single>.

=over

=item success 

=item failure

=item add_message
        
=item info 

=item warning 

=item error
        
=item field_info 

=item field_warning 

=item field_error

=back

=head1 WORKFLOW

=head2 TYPICAL CASE

The action workflow typically goes like this. There are two phases.

=head3 PHASE 1: SHOW THE FORM

Phase 1 is responsible for showing the form to the user. This phase might be skipped altogether in situations where automatic processing is taking place where the robot doing the work already knows what inputs are expected for the action. However, typically, you do something like this:

  my $action = $factory->new_action('Foo');
  $action->unstash('foo');
  $action->render;
  $action->render_control(button => {
      name  => 'submit',
      label => 'Do It',
  });
  $action->stash('foo');

This tells the factory that you want to prepare a form object for class "Foo." 

The call to L</unstash> then pulls in any state saved from the user's prior entry. This will cause any errors that occurred on a previous validation or process execution to show up (assuming that your factory does that work for you). This also means that any previously stashed values entered should reappear in the form so that a failure to save or something won't cause the field information to be lost forever.

The call to L</render> causes all of the controls of the form to be rendered for input.

The call to L</render_control> causes a button to appear in the form.

The call to L</stash> returns the form's stashable information back to the stash, since L</unstash> typically removes it.

=head3 PHASE 2: PROCESSING THE INPUT

Once the user has submitted the form, you will want to process the input and perform the action. This typically looks like this:

  my $action = $factory->new_action('Foo');
  $action->unstash('foo');
  $action->consume_and_clean_and_check_and_process( request => $q->Vars );

  if ($action->is_valid and $action->is_success) {
      # Go on to the next thing
  }
  else {
      $action->stash('foo');
      # Go render the form again and show the errors
  }

We request an instance of the form again and then call L</unstash> to recover any stashed setup. We then call the L</consume_and_clean_and_check_and_process> method, which will consume all the input. Here we use something that looks like a L<CGI> request for the source of input, but it should be whatever is appropriate to your environment and the L<FormFactory::Factory> implementation used. 

At the end, we check to see if the action checked out and then that the L</run> method ran without problems. If so, we can show the success page or the record view or whatever is appropriate after filling this form.

If there are errors, we should perform the rendering action for L</PHASE 1: SHOW THE FORM> again after doing a L</stash> to make sure the information is ready to be recovered.

=head2 VARATIONS

=head3 PER-CONTROL CLEANING AND CHECKING

Ajax or GUIs will generally want to give their feedback as early as possible. As such, whenever the user finishes entering a value or the application thinks that validation is needed, the app might perform:

  $action->check( controls => [ qw( some_control ) ] );
  $action->clean( controls => [ qw( some_control ) ] );

  unless ($action->is_valid) {
      # Report $action->results->error_messages
  }

You will still run the steps above, but can do a check and clean on a subset of controls when you need to do so to give the user early feedback.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
