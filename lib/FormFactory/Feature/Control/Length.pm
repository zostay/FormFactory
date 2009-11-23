package FormFactory::Feature::Control::Length;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

has minimum => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_minimum',
);

has maximum => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_maximum',
);

sub BUILDARGS {
    my $class = shift;
    my $args  = @_ == 1 ? $_[0] : { @_ };

    if (defined $args->{minimum} and defined $args->{maximum}
            and $args->{minimum} >= $args->{maximum}) {
        die 'length minimum must be less than maximum';
    }

    return $class->SUPER::BUILDARGS(@_);
}

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');

    die "the length feature only works with scalar values\n";
}

sub check_value {
    my $self  = shift;
    my $value = $self->control->current_value;

    return if length($value) == 0;

    if ($self->has_minimum and length($value) < $self->minimum) {
        $self->control_error(
            "the %s must be at least @{[$self->minimum]} characters long"
        );
    }

    if ($self->has_maximum and length($value) > $self->maximum) {
        $self->control_error(
            "the %s must be no longer than @{[$self->maximum]} characters"
        );
    }
}

1;
