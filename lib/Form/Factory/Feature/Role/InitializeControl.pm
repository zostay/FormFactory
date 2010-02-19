package Form::Factory::Feature::Role::InitializeControl;
use Moose::Role;

requires qw( initialize_control );

=head1 NAME

Form::Factory::Feature::Role::InitializeControl - control features that work on just constructed controls

=head1 SYNOPSIS

  package MyApp::Feature::Control::LoadDBValue;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::Control
      Form::Factory::Feature::Role::InitializeControl
  );

  sub check_control { 
      my ($self, $control) = @_;

      # nasty ducks and they typings
      die "control action has no record"
          unless $control->action->can('record');
  }

  sub initialize_control {
      my $self    = shift;
      my $action  = $self->action;
      my $control = $self->control;

      my $name   = $control->name;
      my $record = $action->record;

      # Set the default value from the record value
      $control->default_value( $record->$name );
  }

  package Form::Factory::Feature::Control::Custom::LoadDatabaseValue;
  sub register_implementation { 'MyApp::Feature::Control::LoadDBValue' }

=head1 DESCRIPTION

This role may be implemented by a control feature that needs to access a control and do something with it immediately after the control has been completely constructed.

The feature must implement the C<initialize_control> method.

=head1 ROLE METHODS

=head2 initialize_control

This method is called on the feature immediately after the control has been completely constructed. This method is called with no arguments and the return value is ignored.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
