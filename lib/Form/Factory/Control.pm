package Form::Factory::Control;
use Moose::Role;

use Form::Factory::Control::Choice;
use List::Util qw( first );

requires qw( default_isa );

=head1 NAME

Form::Factory::Control - high-level API for working with form controls

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

=head2 documentation

This holds a copy the documentation attribute of the original meta attribute.

=cut

has documentation => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_documentation',
);

=head2 feature

This is the list of L<Form::Factory::Feature::Role::Control> features associated with the control.

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

=head1 METHODS

=head2 get_feature_by_name

  my $feature = $control->get_feature_by_name($name);

Given a feature name, it returns the named feature object. Returns C<undef> if no such feature is attached to this control.

=cut

sub get_feature_by_name {
    my ($self, $name) = @_;
    return first { $_->name eq $name } @{ $self->features };
}

=head2 has_feature

  if ($control->has_feature($name)) {
      # do something about it...
  }

Returns a true value if the named feature is attached to this control. Returns false otherwise.

=cut

sub has_feature {
    my ($self, $name) = @_;
    return 1 if $self->get_feature_by_name($name);
    return '';
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
