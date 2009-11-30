package Form::Factory::Control::SelectOne;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::AvailableChoices
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::SelectOne - A control for selecting a single item

=head1 SYNOPSIS

  has_control popup_menu => (
      control => 'select_one',
      options => {
          available_choices => [
              Form::Factory::Control::Choice->new('one'),
              Form::Factory::Control::Choice->new('two'),
              Form::Factory::Control::Choice->new('three'),
          ],
          default_value => 'two',
      },
  );

=head1 DESCRIPTION

A select control that allows a single selection. A list of radio buttons or a drop-down box would be appropriate.

=head1 ATTRIBUTES

=head2 value

The current value of the control.

=cut

has value => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_value',
);

=head2 default_value

The defautl value of the control.

=cut

has default_value => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_default_value',
);

=head2 stashable_keys

The L</value> is stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( value ) ] },
);

=head1 METHODS

=head2 current_value

If L</value> is set, use that. Otherwise, if L</default_value> is set, use that. Otherwise, returns an empty string.

=cut

sub current_value {
    my $self = shift;
    $self->value(shift) if @_;
    return $self->has_value         ? $self->value
         : $self->has_default_value ? $self->default_value
         :                            '';
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
