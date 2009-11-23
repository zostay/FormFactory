package FormFactory::Feature::Control::MatchCode;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

has code => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
);

sub check_control { }

sub check_value {
    my $self  = shift;
    my $value = $self->control->current_value;

    unless ($self->code->($value)) {
        $self->control_error('the %s is not correct');
    }
}

1;
