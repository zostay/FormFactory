package Form::Factory::Feature::Control::MatchCode;

use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Check
    Form::Factory::Feature::Role::Control
    Form::Factory::Feature::Role::CustomControlMessage
);

use Carp ();

=head1 NAME

Form::Factory::Feature::Control::MatchCode - Greps the control value for correctness

=head1 SYNOPSIS

  has_control even_value => (
      control => 'text',
      features => {
          match_code => {
              message => 'the value in %s is not even',
              code    => sub { shift % 2 == 0 },
          },
      },
  );

=head1 DESCRIPTION

Runs the control value against a code reference during the check. If that code reference returns a false value, an error is generated.

=head1 ATTRIBUTES

=head2 code

This is the code reference. It should expect a single argument to be passed, which is the value to check.

=cut

has code => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
);

=head1 METHODS

=head2 check_control

No op.

=cut

sub check_control { }

=head2 check

Does the work of running the given subroutine over the control value and reports an error if the code reference runs and returns a false value.

=cut

sub check {
    my $self    = shift;
    my $control = $self->control;
    my $value   = $control->current_value;

    unless ($self->code->($value)) {
        $self->control_error('the %s is not correct');
        $self->result->is_valid(0);
    }

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
