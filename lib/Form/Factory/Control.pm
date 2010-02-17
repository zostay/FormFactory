package Form::Factory::Control;
use Moose::Role;

use Form::Factory::Control::Choice;
use List::Util qw( first );

requires qw( default_isa );

=head1 NAME

Form::Factory::Control - high-level API for working with form controls

=head1 SYNOPSIS

  package MyApp::Control::Slider;
  use Moose;

  with qw(
      Form::Feature::Control
      Form::Feature::Control::Role::ScalarValue
  );

  has minimum_value => (
      is        => 'rw',
      isa       => 'Num',
      required  => 1,
      default   => 0,
  );

  has maximum_value => (
      is        => 'rw',
      isa       => 'Num',
      required  => 1,
      default   => 100,
  );

  has value => (
      is        => 'rw',
      isa       => 'Num',
      required  => 1,
      default   => 50,
  );

  sub current_value {
      my $self = shift
      if (@_) { $self->value(shift) }
      return $self->value;
  }

  package Form::Factory::Control::Custom::Slider;
  sub register_implementation { 'MyApp::Control::Slider' }

=head1 DESCRIPTION

Allows for high level processing, validation, filtering, etc. of form control information.

=head1 ATTRIBUTES

=head2 name

This is the base name for the control.

=cut

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

=head2 documentation

This holds a copy the documentation attribute of the original meta attribute.

=cut

has documentation => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_documentation',
);

=head2 features

This is the list of L<Form::Factory::Feature::Role::Control> features associated with the control.

=cut

has features => (
    is        => 'ro',
    isa       => 'ArrayRef',
    required  => 1,
    default   => sub { [] },
);

=head2 value

This is the value of the control. This attribute provides a C<has_value> predicate. See L</current_value>.

=cut

has value => (
    is        => 'rw',
    predicate => 'has_value',
);

=head2 default_value

This is the default or fallback value for the control used when L</value> is not set. This attribute provides a C<has_default_value> predicate. See L</current_value>.

=cut

has default_value => (
    is        => 'rw',
    predicate => 'has_default_value',
);

=head1 METHODS

=head2 current_value

This is the current value of the control. If L</value> is set, then that is returned. If that is not set, but L</defautl_value> is set, then that is returned. If neither are set, then C<undef> is returned.

This may also be passed a value. In which case the L</value> is set and that value is returned.

=cut

sub current_value {
    my $self = shift;

    $self->value(@_) if @_;

    return $self->value         if $self->has_value;
    return $self->default_value if $self->has_default_value;
    return scalar undef;
}

=head2 has_current_value

Returns true if either C<value> or C<default_value> is set.

=cut

sub has_current_value {
    my $self = shift;
    return $self->has_value || $self->has_default_value;
}

=head2 convert_value_to_control

Given an attribute value, convert it to a control value. This will cause any associated L<Form::Factory::Feature::Role::ControlValueConverter> features to run and run the L</value_to_control> conversion. The value to convert should be passed as the lone argument. The converted value is returned.

=cut

sub convert_value_to_control {
    my ($self, $value) = @_;

    for my $feature (@{ $self->features }) {
        next unless $feature->does('Form::Factory::Feature::Role::ControlValueConvert');

        $value = $feature->value_to_control($value);
    }

    if ($self->has_value_to_control) {
        my $converter = $self->value_to_control;
        if (ref $converter) {
            $value = $converter->($self->action, $self, $value);
        }
        else {
            $value = $self->action->$converter($self, $value);
        }
    }

    return $value;
}

=head2 convert_control_to_value

Given a control value, convert it to an attribute value. This will run any L<Form::Factory::Feature::Role::ControlValueConverter> features and the L</control_to_value> conversion (if set). The value to convert should be passed as the only argument and the converted value is returned.

=cut

sub convert_control_to_value {
    my ($self, $value) = @_;

    for my $feature (@{ $self->features }) {
        next unless $feature->does('Form::Factory::Feature::Role::ControlValueConvert');

        $value = $feature->control_to_value($value);
    }

    if ($self->has_control_to_value) {
        my $converter = $self->control_to_value;
        if (ref $converter) {
            $value = $converter->($self->action, $self, $value);
        }
        else {
            $value = $self->action->$converter($self, $value);
        }
    }

    return $value;
}

=head2 set_attribute_value

  $control->set_attribute_value($action, $attribute);

Sets the value of the action attribute with current value of teh control.

=cut

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;

    my $value = $self->current_value;
    if (defined $value) {
        $value = $self->convert_control_to_value($value);
        $attribute->set_value($action, $value);
    }
    else {
        $attribute->clear_value($action);
    }
}

=head2 get_feature_by_name

  my $feature = $control->get_feature_by_name($name);

Given a feature name, it returns the named feature object. Returns C<undef> if no such feature is attached to this control.

=cut

sub get_feature_by_name {
    my ($self, $name) = @_;
    return first { $_->name eq $name } @{ $self->features };
}

=head2 has_feature

  if ($control->has_feature($name)) {
      # do something about it...
  }

Returns a true value if the named feature is attached to this control. Returns false otherwise.

=cut

sub has_feature {
    my ($self, $name) = @_;
    return 1 if $self->get_feature_by_name($name);
    return '';
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
