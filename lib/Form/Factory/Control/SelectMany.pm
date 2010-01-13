package Form::Factory::Control::SelectMany;
use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::AvailableChoices
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ListValue
);

use List::MoreUtils qw( any );

=head1 NAME

Form::Factory::Control::SelectMany - the multi-select control

=head1 SYNOPSIS

  has_control pick_some => (
      control => 'select_many',
      options => {
          label => 'Just select some of these already...",
          available_choices => [
              Form::Factory::Control::Choice->new('one');
              Form::Factory::Control::Choice->new('two');
              Form::Factory::Control::Choice->new('three');
          ],
          default_selected_choices => [ qw( one three ) ],
      },
  );

=head1 DESCRIPTION

A select many can be displayed as a multi-select list box or a list of checkboxes.

This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::AvailableChoices>, L<Form::Factory::Control::Role::Labeled>, L<Form::Factory::Control::Role::ListValue>.

=head1 ATTRIBUTES

=head2 default_value

This is a list of the default selection.

=cut

has default_value => (
    is        => 'rw',
    isa       => 'ArrayRef',
    predicate => 'has_default_value',
);

=head2 stashable_keys

The L</selected_choices> are stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( selected_choices ) ] },
);

=head1 METHODS

=head2 selected_choices

This is a synonym for C<value>.

=head2 has_selected_choices

This is a synonyms for C<has_selected_choices>.

=cut

sub selected_choices { shift->value(@_) }

sub has_selected_choices { shift->has_value(@_) }

=head2 default_selected_choices

This is a synonym for C<default_value>.

=head2 has_default_selected_choices

This is a synonym for C<has_default_selected_choices>.

=cut

sub default_selected_choices { shift->default_value(@_) }

sub has_default_selected_choices { shift->has_default_value(@_) }

=head2 current_value

Returns the L</value>, if set. Failing that, it returns the L</default_value>, if set. Failing that, it returns an empty list.

=cut

sub current_value {
    my $self = shift;
    $self->value(@_) if @_;
    return $self->has_value         ? $self->value
         : $self->has_default_value ? $self->default_value
         :                            []
         ;
}

=head2 is_choice_selected

  for my $choice (@{ $self->available_choices }) {
      if ($control->is_choice_selected($choice)) {
          # ...
      }
  }

This is a helper that is useful while iterating over the available choices in deciding which have been selected.

=cut

sub is_choice_selected {
    my ($self, $choice) = @_;

    return any { $_ eq $choice->value } @{ $self->current_values };
}

=head2 has_current_value

If more than zero values have been selected, we have a useful value.

=cut

sub has_current_value {
    my $self = shift;

    my $values = $self->current_value;
    return scalar(@$values) > 0;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
