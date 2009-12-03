package Form::Factory::Control::Button;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::Button - The button control

=head1 SYNOPSIS

  has_control a_button => (
      control => 'button',
      options => {
          label => 'My Button',
      },
  );

=head1 DESCRIPTION

A control representing a submit button. This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::Labeled>, L<Form::Factory::Control::Role::ScalarValue>.

=cut

has '+true_value' => (
    isa       => 'Str',
    lazy      => 1,
    default   => sub { shift->label },
);

=head1 METHODS

=head2 current_value

The current value is always the same as the C<label>.

=cut

sub current_value { 
    my $self = shift;

    if (@_) {
        my $value = shift;
        $self->is_true($self->true_value eq $value);
    }

    return $self->is_true ? $self->true_value : $self->false_value;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
