package Form::Factory::Control::Value;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::HiddenValue
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::PresetValue
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::Value - A read-only value control

=head1 SYNOPSIS

  has_control preset_value => (
      control => 'value',
      options => {
          label      => 'Preset',
          is_visible => 1,
          value      => 'Neo',
      },
  );

=head1 DESCRIPTION

A read-only value. These may be displayed in the form or just passed through the stash. They might be passed by form submission as well (depending on the interface, but this should be avoided).

This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::Labeled>, L<Form::Factory::Control::Role::ScalarValue>.

=head1 ATTRIBUTES

=head2 is_visible

Set to true if the read-only value should be displayed.

=cut

has is_visible => (
    is        => 'ro',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

=head2 value

The value the control should have.

=cut

has value => (
    is        => 'rw',
    isa       => 'Str',
    required  => 1,
);

=head2 stashable_keys

The L</value> is stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( value ) ] },
);

=head1 METHODS

=head2 current_value

Returns the L</value>.

=cut

sub current_value { 
    my $self = shift;
    $self->value(shift) if @_;
    return $self->value;
};

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
