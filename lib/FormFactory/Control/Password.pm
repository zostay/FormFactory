package FormFactory::Control::Password;
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

sub current_value {
    my $self = shift;
    $self->value(shift) if @_;
    return $self->has_value ? $self->value
         :                    '';
}

1;
