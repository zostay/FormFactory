package Form::Factory::Control::Checkbox;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::Checkbox - the checkbox control

=head1 SYNOPSIS

  has_control yes_no_box => (
      control => 'checkbox',
      options => {
          true_value  => 'Yes',
          false_value => 'No',
          is_true     => 1,
      },
  );

=head1 DESCRIPTION

This represents a toggle button, typically displayed as a checkbox. This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::BooleanValue>, L<Form::Factory::Control::Role::Labeled>, L<Form::Factory::Control::Role::ScalarValue>.

=cut

has '+true_value' => (
    isa       => 'Str',
);

has '+false_value' => (
    isa       => 'Str',
);

=head2 stashable_keys

The L</is_true> attribute is stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( is_true ) ] },
);

=head1 METHODS

=head2 current_value

Returns the L</true_value> if L</is_true> is true. Returns L</false_value> otherwise.

=cut

sub current_value {
    my $self = shift;

    if (@_) {
        my $true = shift;
        $self->is_true($self->true_value eq $true);
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
