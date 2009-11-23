package FormFactory::Control::Role::Labeled;
use Moose::Role;

has label => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    builder   => 'build_label',
);

sub build_label {
    my $self = shift;
    my $label = $self->name;
    $label =~ s/_/ /g;
    $label =~ s/\b(\w)/\U$1\E/g;
    return $label;
}

1;
