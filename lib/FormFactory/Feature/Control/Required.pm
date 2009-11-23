package FormFactory::Feature::Control::Required;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');
    return if $control->does('FormFactory::Control::Role::ListValue');

    die "the required feature does not know how to check the value of $control";
}

sub check_value {
    my $self    = shift;
    my $control = $self->control;

    # Handle scalar value controls
    if ($control->does('FormFactory::Control::Role::ScalarValue')) {
        my $value = $control->current_value;
        unless (length($value) > 0) {
            $self->control_error('the %s is required');
        }
    }

    # Handle list value controls
    else { 
        my $values = $control->current_values;
        unless (@$values > 0) {
            $self->control_error('at least one value for %s is required');
        }
    }
}

1;
