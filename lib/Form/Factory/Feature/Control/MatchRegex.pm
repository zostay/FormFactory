package FormFactory::Feature::Control::MatchRegex;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

=head1 NAME

FormFactory::Feature::Control::MatchRegex - Match a control value against a regex

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
    isa       => 'Regexp',
    required  => 1,
);

=head1 METHODS

=head2 check_control

Checks that the control does L<FormFactory::Control::Role::ScalarValue>.

=cut

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');

    die "the match_regex feature only works with scalar value controls, not $control";
}

=head2 check_value

Runs the regular expression against the current value of the control and reports an error if it does not match.

=cut

sub check_value {
    my $self  = shift;
    my $value = $self->control->current_value;

    my $regex = $self->regex;
    unless ($value =~ /$regex/) {
        $self->control_error("the %s does not match $regex");
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
