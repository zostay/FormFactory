package FormFactory::Control::Value;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ScalarValue
);

has is_visible => (
    is        => 'ro',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

has value => (
    is        => 'rw',
    isa       => 'Str',
    required  => 1,
);

has '+stashable_keys' => (
    default   => sub { [ qw( value ) ] },
);

sub current_value { 
    my $self = shift;
    $self->value(shift) if @_;
    return $self->value;
};

1;
