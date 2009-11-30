package FormFactory::Control::SelectMany;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::AvailableChoices
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ListValue
);

use List::MoreUtils qw( any );

=head1 NAME

FormFactory::Control::SelectMany - the multi-select control

=head1 SYNOPSIS

  has_control pick_some => (
      control => 'select_many',
      options => {
          label => 'Just select some of these already...",
          available_choices => [
              FormFactory::Control::Choice->new('one');
              Formfactory::Control::Choice->new('two');
              FormFactory::Control::Choice->new('three');
          ],
          default_selected_choices => [ qw( one three ) ],
      },
  );

=head1 DESCRIPTION

A select many can be displayed as a multi-select list box or a list of checkboxes.

This control implements L<FormFactory::Control>, L<FormFactory::Control::Role::AvailableChoices>, L<FormFactory::Control::Role::Labeled>, L<FormFactory::Control::Role::ListValue>.

=head1 ATTRIBUTES

=head2 selected_choices

This is a list of currently selected choices.

=cut

has selected_choices => (
    is        => 'rw',
    isa       => 'ArrayRef[Str]',
    predicate => 'has_selected_choices',
);

=head2 default_choices

This s a list of the default selection.

=cut

has default_selected_choices => (
    is        => 'rw',
    isa       => 'ArrayRef[Str]',
    predicate => 'has_default_selected_choices',
);

=head2 stashable_keys

The L</selected_choices> are stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( selected_choices ) ] },
);

=head1 METHODS

=head2 current_values

Returns the L</selected_choices>, if set. Failing that, it returns the L</default_selected_choices>, if set. Failnig that, it returns an empty list.

=cut

sub current_values {
    my $self = shift;
    $self->selected_choices(shift) if @_;
    return $self->has_selected_choices         ? $self->selected_choices
         : $self->has_default_selected_choices ? $self->default_selected_choices
         :                                       []
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

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
