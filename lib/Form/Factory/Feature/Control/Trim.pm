package Form::Factory::Feature::Control::Trim;

use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Clean
    Form::Factory::Feature::Role::Control
);

use Carp ();

# ABSTRACT: Trims whitespace from a control value

=head1 SYNOPSIS

  has_control title => (
      control => 'text',
      features => {
          trim => 1,
      },
  );

=head1 DESCRIPTION

Strips whitespace from the front and back of the given values.

=head1 METHODS

=head2 check_control

Reports an error unless the control is a scalar value.

=cut

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('Form::Factory::Control::Role::ScalarValue');

    Carp::croak("the trim feature only works on scalar values, not $control");
}

=head2 clean

Strips whitespace from the start and end of the control value.

=cut

sub clean {
    my $self    = shift;
    my $control = $self->control;

    my $value   = $control->current_value;
    $value =~ s/^\s*//;
    $value =~ s/\s*$//;

    $control->current_value($value);
}

1;
