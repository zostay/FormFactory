package Form::Factory::Control::Value;

use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::HiddenValue
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::PresetValue
    Form::Factory::Control::Role::ScalarValue
);

# ABSTRACT: A read-only value control

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

=cut

has '+value' => (
    required  => 1,
);

=head2 is_visible

Set to true if the read-only value should be displayed.

=cut

has is_visible => (
    is        => 'ro',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

__PACKAGE__->meta->make_immutable;
