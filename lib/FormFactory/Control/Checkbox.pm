package FormFactory::Control::Checkbox;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ScalarValue
);

=head1 NAME

FormFactory::Control::Checkbox - the checkbox control

=head1 SYNOPSIS

  has_control yes_no_box => (
      control => 'checkbox',
      options => {
          checked_value   => 'Yes',
          unchecked_value => 'No',
          is_checked      => 1,
      },
  );

=head1 DESCRIPTION

This represents a toggle button, typically displayed as a checkbox. This control implements L<FormFactory::Control>, L<FormFactory::Control::Role::Labeled>, L<FormFactory::Control::Role::ScalarValue>.

=head1 ATTRIBUTES

=head2 checked_value

The string value the control should have when toggled to the checked or on position.

=cut

has checked_value => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => 1,
);

=head2 unchecked_value

The string value the control should have when toggled to the unchecked or off position.

=cut

has unchecked_value => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => 0,
);

=head2 is_checked

Whether or not the checkbox is currently toggeld to the checked or on position or not.

=cut

has is_checked => (
    is        => 'rw',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

=head2 stashable_keys

The L</is_checked> attribute is stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( is_checked ) ] },
);

=head1 METHODS

=head2 current_value

Returns the L</checked_value> if L</is_checked> is true. Returns L</unchecked_value> otherwise.

=cut

sub current_value {
    my $self = shift;

    if (@_) {
        my $checked = shift;
        $self->is_checked($self->checked_value eq $checked);
    }

    return $self->is_checked ? $self->checked_value : $self->unchecked_value;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
