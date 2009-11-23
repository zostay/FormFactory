package FormFactory::Control::Button;
use Moose;

with qw(
    FormFactory::Control
    FormFactory::Control::Role::Labeled
    FormFactory::Control::Role::ScalarValue
);

sub current_value { 
    my $self = shift;
    warn "attempt to change read-only label failed" if @_;
    return $self->label;
}

1;
