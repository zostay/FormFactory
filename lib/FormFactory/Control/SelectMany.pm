package FormFactory::Cotnrol::SelectMany;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::AvailableChoices
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ListValue
);

use List::MoreUtils qw( any );

has selected_choices => (
    is        => 'rw',
    isa       => 'ArrayRef[Str]',
    required  => 1,
    predicate => 'has_selected_choices',
);

has default_selected_choices => (
    is        => 'rw',
    isa       => 'ArrayRef[Str]',
    predicate => 'has_default_selected_choices',
);

has '+stashable_keys' => (
    default   => sub { [ qw( selected_choices ) ] },
);

sub current_values {
    my $self = shift;
    $self->selected_choices(shift) if @_;
    return $self->has_selected_choices         ? $self->selected_choices
         : $self->has_default_selected_choices ? $self->default_selected_choices
         :                                       []
         ;
}

sub is_choice_selected {
    my ($self, $choice) = @_;

    return any { $_ eq $choice->value } @{ $self->current_values };
}

1;
