package FormFactory::Feature::Control::Length;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

=head1 NAME

FormFactory::Feature::Control::Length - A control feature for checking length

=head1 SYNOPSIS

  has_control login_name => (
      control => 'text',
      feature => {
          length => {
              minimum => 3,
              maximum => 15,
          },
      },
  );

=head1 DESCRIPTION

Linked to a control, it checks to see that the string is not too short or too long.

=head1 ATTRIBUTES

=head2 minumum

The optional minimum length permitted for the string.

=cut

has minimum => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_minimum',
);

=head2 maximum

The optional maximum length permitted for the string.

=cut

has maximum => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_maximum',
);

sub BUILDARGS {
    my $class = shift;
    my $args  = @_ == 1 ? $_[0] : { @_ };

    if (defined $args->{minimum} and defined $args->{maximum}
            and $args->{minimum} >= $args->{maximum}) {
        die 'length minimum must be less than maximum';
    }

    return $class->SUPER::BUILDARGS(@_);
}

=head1 METHODS

=head2 check_control

Makes sure the value is a L<FormFactory::Control::Role::ScalarValue>.

=cut

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');

    die "the length feature only works with scalar values\n";
}

=head2 check_value

Verifies that the value of the control is not too short or too long.

=cut

sub check_value {
    my $self  = shift;
    my $value = $self->control->current_value;

    return if length($value) == 0;

    if ($self->has_minimum and length($value) < $self->minimum) {
        $self->control_error(
            "the %s must be at least @{[$self->minimum]} characters long"
        );
    }

    if ($self->has_maximum and length($value) > $self->maximum) {
        $self->control_error(
            "the %s must be no longer than @{[$self->maximum]} characters"
        );
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
