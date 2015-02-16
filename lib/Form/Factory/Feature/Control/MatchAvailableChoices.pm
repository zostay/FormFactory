package Form::Factory::Feature::Control::MatchAvailableChoices;

use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Check
    Form::Factory::Feature::Role::Control
    Form::Factory::Feature::Role::CustomControlMessage
);

use Carp ();

=head1 NAME

Form::Factory::Feature::Control::MatchAvailableChoices - Check for choice availability

=head1 SYNOPSIS

  has_control time_zone => (
      control => 'select_one',
      options => {
          available_choices => [
              map { Form::Factory::Control::Choice->new($_) } qw( PST MST CST EST )
          ],
      },
      features => {
          match_available_choices => 1,
      },
  );

=head1 DESCRIPTION

Verifies that the value set for the control matches one of the available choices.

=head1 METHODS

=head2 check_control

Verifies that the control does the L<Form::Factory::Control::Role::AvailableChoices>.

=cut

sub check_control {
    my ($self, $control) = @_;

    Carp::croak("the match_available_options feature only works for controls that have available choices, not $control")
        unless $control->does('Form::Factory::Control::Role::AvailableChoices');
}

=head2 check

Verifies that the value or values set match one or more of the available values.

=cut

sub check {
    my $self    = shift;
    my $control = $self->control;

    my %available_values = map { $_->value => 1 } 
        @{ $self->control->available_choices };

    # Deal with list valued controls
    if ($control->does('Form::Factory::Control::Role::ListValue')) {
        my $values = $control->current_values;
        VALUE: for my $value (@$values) {
            unless ($available_values{ $value }) {
                $self->control_error('one of the values given for %s is not in the list of available choices');
                $self->result->is_valid(0);
                last VALUE;
            }
        }
    }

    # Deal with scalar valued controls
    else {
        my $value = $control->current_value;
        unless ($available_values{ $value }) {
            $self->control_error('the given value for %s is not one of the available choices');
            $self->is_valid(0);
        }
    }

    # If not already validated
    $self->result->is_valid(1) unless $self->result->is_validated;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
