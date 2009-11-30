package FormFactory::Feature::Control::Required;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

=head1 NAME

FormFactory::Feature::Control::Required - Makes sure a value is set on a control

=head1 SYNOPSIS

  has_control last_name => (
      control => 'text',
      features => {
          required => 1,
      },
  );

=head1 DESCRIPTION

Reports a check error if the required value is not set. On scalar value controls, it checks that the value has a length greater than zero. On list value controls, it makes sure the list of selected items has more than zero elements.

=head1 METHODS

=head2 check_control

Only works with scalar and list valued controls.

=cut

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');
    return if $control->does('FormFactory::Control::Role::ListValue');

    die "the required feature does not know how to check the value of $control";
}

=head2 check_value

Reports an error if a scalar value does not have a length greater than 0. Reports an error if a list value has 0 items in the list.

=cut

sub check_value {
    my $self    = shift;
    my $control = $self->control;

    # Handle scalar value controls
    if ($control->does('FormFactory::Control::Role::ScalarValue')) {
        my $value = $control->current_value;
        unless (length($value) > 0) {
            $self->control_error('the %s is required');
        }
    }

    # Handle list value controls
    else { 
        my $values = $control->current_values;
        unless (@$values > 0) {
            $self->control_error('at least one value for %s is required');
        }
    }
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
