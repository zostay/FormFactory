package FormFactory::Control::Choice;
use Moose;

has label => (
    is        => 'ro',
    isa       => 'Str',
);

has value => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

sub BUILDARGS {
    my $class = shift;
    my %args;

    if (@_ == 1 and ref $_[0]) {
        %args = %{ $_[0] };
    }
    elsif (@_ == 1) {
        $args{value} = $_[0];
    }
    elsif (@_ == 2) {
        $args{value} = $_[0];
        $args{label} = $_[1];
    }
    else {
        %args = @_;
    }

    $args{label} = $args{value} unless defined $args{label};

    return $class->SUPER::BUILDARGS(%args);
}

1;
