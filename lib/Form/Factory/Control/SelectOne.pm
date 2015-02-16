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

=cut

has '+value' => (
    isa       => 'Str',
);

has '+default_value' => (
    isa       => 'Str',
);

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
