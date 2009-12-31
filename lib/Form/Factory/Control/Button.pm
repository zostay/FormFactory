package Form::Factory::Control::Button;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::Labeled
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

A control representing a submit button. This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::BooleanValue>, L<Form::Factory::Control::Role::Labeled>, L<Form::Factory::Control::Role::ScalarValue>.

=head1 ATTRIBUTES

=head2 true_value

See L<Form::Factory::Control::Role::BooleanValue>. By default, this value is set
to the label. If you change this to something else, the button might not work
correctly anymore.

=cut

has '+true_value' => (
    isa       => 'Str',
    lazy      => 1,
    default   => sub { shift->label },
);

=head2 value

See L<Form::Factory::Control::Role::Value>.

=cut

has '+value' => (
    isa       => 'Str',
);

=head1 METHODS

=head2 default_isa

Boolean values default to C<Bool>.

=cut

use constant default_isa => 'Str';

=head2 current_value

The current value expects the L</true_value> to be passed to set the L<Form::Factory::Control::Role::BooleanValue/is_true> attribute. This method returns either the L</true_value> or L<Form::Factory::Control::Role::BooleanValue/false_value>.

If the control is neither true nor false, it returns C<undef>.

=cut

sub current_value { 
    my $self = shift;

    if (@_) {
        $self->value(@_);
    }

    # blow off these warnings rather than test for them
    no warnings 'uninitialized';

    return $self->true_value  if $self->true_value  eq $self->value;
    return $self->false_value if $self->false_value eq $self->value;
    return;
}

=head2 has_current_value

If the value is true or false, it has a current value. Otherwise, it does not.

=cut

sub has_current_value {
    my $self = shift;

    return ($self->true_value  eq $self->value
         || $self->false_value eq $self->value);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
