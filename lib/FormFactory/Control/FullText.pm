package FormFactory::Control::FullText;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ScalarValue
);

has value => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_value',
);

has default_value => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_default_value',
);

has '+stashable_keys' => (
    default   => sub { [ qw( value ) ] },
);

sub current_value {
    my $self = shift;
    $self->value(shift) if @_;
    return $self->has_value         ? $self->value
         : $self->has_default_value ? $self->default_value
         :                            '';
}

1;
