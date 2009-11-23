package FormFactory::Feature::Control::MatchRegex;
use Moose;

with qw( 
    FormFactory::Feature 
    FormFactory::Feature::Role::Control
);

has regex => (
    is        => 'ro',
    isa       => 'Regexp',
    required  => 1,
);

sub check_control {
    my ($self, $control) = @_;

    return if $control->does('FormFactory::Control::Role::ScalarValue');

    die "the match_regex feature only works with scalar value controls, not $control";
}

sub check_value {
    my $self  = shift;
    my $value = $self->control->current_value;

    my $regex = $self->regex;
    unless ($value =~ /$regex/) {
        $self->control_error("the %s does not match $regex");
    }
}

1;
