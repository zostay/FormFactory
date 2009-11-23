package FormFactory::Control;
use Moose::Role;

use List::Util qw( first );

=head1 NAME

FormFactory::Control - high-level API for working with form controls

=head1 DESCRIPTION

Allows for high level processing, validation, filtering, etc. of form control information.

=head1 ATTRIBUTES

=head2 name

This is the base name for the control.

=cut

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

=head2 feature

This is the list of L<FormFactory::Feature::Role::Control> features associated with the control.

=cut

has features => (
    is        => 'ro',
    isa       => 'ArrayRef',
    required  => 1,
    default   => sub { [] },
);

=head2 stashable_keys

This is the list of control keys that may be stashed.

=cut

# TODO This really ought to be a meta-attribute.
has stashable_keys => (
    is        => 'ro',
    isa       => 'ArrayRef',
    required  => 1,
    lazy      => 1,
    default   => sub { [] },
);

sub get_feature_by_name {
    my ($self, $name) = @_;
    return first { $_->name eq $name } @{ $self->features };
}

sub has_feature {
    my ($self, $name) = @_;
    return 1 if $self->get_feature_by_name($name);
    return '';
}

1;
