package Form::Factory::Control::Checkbox;

use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::Labeled
);

# ABSTRACT: the checkbox control

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

has '+value' => (
    isa       => 'Str',
);

has '+default_value' => (
    isa       => 'Str',
    lazy      => 1,
    default   => sub { shift->false_value },
);

=head1 METHODS

=head2 default_isa

Boolean values default to C<Bool>.

=cut

use constant default_isa => 'Str';

1;
