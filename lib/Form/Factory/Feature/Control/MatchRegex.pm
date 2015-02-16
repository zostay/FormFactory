package Form::Factory::Feature::Control::MatchRegex;

use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Check
    Form::Factory::Feature::Role::Control
    Form::Factory::Feature::Role::CustomControlMessage
);

use Carp ();

=head1 NAME

Form::Factory::Feature::Control::MatchRegex - Match a control value against a regex

=head1 SYNOPSIS

  has_control five_char_palindrome => (
      control => 'text',
      features => {
          match_regex => {
              regex => qr/(.)(.).\2\1/,
              message => 'the %s is not a palindrome',
          },
      },
  );

=head1 DESCRIPTION

Checks that the control value matches a regular expression. Returns an error if it does not.

=head1 ATTRIBUTES

=head2 regex

The regular expression to use.

=cut

has regex => (
    is        => 'ro',
    isa       => 'RegexpRef',
    required  => 1,
);

=head1 METHODS

=head2 check_control

Checks that the control does L<Form::Factory::Control::Role::ScalarValue>.

=cut

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('Form::Factory::Control::Role::ScalarValue');

    Carp::croak("the match_regex feature only works with scalar value controls, not $control");
}

=head2 check

Runs the regular expression against the current value of the control and reports an error if it does not match.

=cut

sub check {
    my $self  = shift;
    my $value = $self->control->current_value;

    my $regex = $self->regex;
    unless ($value =~ /$regex/) {
        $self->control_error("the %s does not match $regex");
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
