package Form::Factory::Control::Role::Labeled;

use Moose::Role;

# ABSTRACT: labeled controls

=head1 DESCRIPTION

Implemented by any control with a label.

=head1 ATTRIBUTES

=head2 label

The label. By default it is created from the control's name.

=cut

has label => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    builder   => '_build_label',
    lazy      => 1,
);

sub _build_label {
    my $self = shift;
    my $label = $self->name;
    $label =~ s/_/ /g;
    $label =~ s/\b(\w)/\U$1\E/g;
    return $label;
}

1;
