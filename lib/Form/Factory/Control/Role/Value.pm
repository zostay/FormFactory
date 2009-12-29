package Form::Factory::Control::Role::Value;
use Moose::Role;

requires qw( current_value );

=head1 NAME

Form::Factory::Control::Role::Value - controls with values

=head1 DESCRIPTION

This flags a control as having a value. This may belong in L<Form::Factory::Control> directly, but for now it is here.

=head1 ATTRIBUTES

=head2 value

This is the value set on the control. It is generally the value that L</current_value> gets or sets.

=cut

has value => (
    is        => 'rw',
    predicate => 'has_value',
);

=head1 METHODS

=head2 set_attribute_value

  $control->set_attribute_value($action, $attribute);

Sets the value of the action attribute with current value of teh control.

=cut

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;

    my $value = $self->current_value;
    if (defined $value) {
        $attribute->set_value($action, $value);
    }
    else {
        $attribute->clear_value($action);
    }
}

=head1 ROLE METHODS

=head2 current_value

  my $value = $control->current_value;
  $control->current_value($new_value);

The C<current_value> method is an accessor and mutator for values on the control. This is different from the L</value> attribute as other attributes or values may be involved in determining what the current value is. For example, a C<text> control defines the C<current_value> something like this:

  sub current_value {
      my $self = shift;

      if (@_) {
          $self->value(@_);
      }

      return $self->has_value         ? $self->value
           : $self->has_default_value ? $self->default_value
           :                            ''
           ;
  }

The value will change if set, but the C<default_value> attribute is used if available and it will fall back to an empty string failing that.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
