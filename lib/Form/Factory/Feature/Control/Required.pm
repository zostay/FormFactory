package Form::Factory::Feature::Control::Required;
use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Check
    Form::Factory::Feature::Role::Control
    Form::Factory::Feature::Role::CustomControlMessage
);

=head1 NAME

Form::Factory::Feature::Control::Required - Makes sure a value is set on a control

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

    return if $control->does('Form::Factory::Control::Role::Value');

    die "the required feature does not know how to check the value of $control";
}

=head2 check

Reports an error if a scalar value does not have a length greater than 0. Reports an error if a list value has 0 items in the list.

=cut

sub check {
    my $self    = shift;
    my $control = $self->control;

    if ($control->has_current_value) {
        $self->result->is_valid(1);
    }

    else {
        $self->control_error('the %s is required');
        $self->result->is_valid(0);
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
