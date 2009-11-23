package FormFactory::Control::Role::ListValue;
use Moose::Role;

requires qw( current_values );

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;
    $attribute->set_value($action, $self->current_value);
}

1;
