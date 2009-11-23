package FormFactory::Control::Role::ScalarValue;
use Moose::Role;

requires qw( current_value );

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;
    $attribute->set_value($action, $self->current_value);
}

1;
