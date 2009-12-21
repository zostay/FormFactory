package Form::Factory::Feature::Role::BuildControl;
use Moose::Role;

requires qw( build_control );

=head1 NAME

Form::Factory::Feature::Role::BuildControl - control features that modify control construction

=head1 SYNOPSIS

  package MyApp::Feature::Control::CapitalizeLabel;
  use Moose;

  with qw(
      Form::Fctory::Feature
      Form::Factory::Feature::Role::BuildControl
      Form::Factory::Feature::Role::Control
  );

  sub build_control {
      my ($class, $options, $control) = @_;

      # could modify the control type too:
      # $control->{control} = 'full_text';

      $control->{options}{label} = uc $control->{options}{label};
  }

  package Form::Factory::Feature::Control::Custom::CapitalizeLabel;
  sub register_implementation { 'MyApp::Feature::Control::CapitalizeLabel' }

=head1 DESCRIPTION

Control features that do this role are given the opportunity to modify how the control is build for the attribute. Any modifications to the C<$options> hash given, whether to the control or to the options themselves will be passed on when creating the control.

In the life cycle of actions, this happens immediately before the control is created, but after any deferred values are evaluated. This means that the given hash should now look exactly as it will before being passed to the C<new_control> method of the interface.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
