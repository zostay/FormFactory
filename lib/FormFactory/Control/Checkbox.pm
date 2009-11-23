package FormFactory::Control::Checkbox;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ScalarValue
);

has checked_value => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => 1,
);

has unchecked_value => (
    is        => 'ro',
    isa       => 'Str',
    requried  => 1,
    default   => 0,
);

has is_checked => (
    is        => 'rw',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

has '+stashable_keys' => (
    default   => sub { [ qw( is_checked ) ] },
);

sub current_value {
    my $self = shift;
    $self->is_checked($self->checked_value eq shift) if @_;
    return $self->is_checked ? $self->checked_value : $self->unchecked_value;
}

1;
