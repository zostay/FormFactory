package Form::Factory::Action::Meta::Role;

use Moose::Role;

# ABSTRACT: The meta-class role for form action roles

=head1 SYNOPSIS

  package MyApp::Action::Role::Foo;
  use Form::Factory::Processor::Role

=head1 DESCRIPTION

All form action roles have this role attached to its meta-class.

=head1 ATTRIBUTES

=head2 features

This is a hash of features provided by the role. The keys are the short name of the feature to attach and the value is a hash of options to pass to the feature's constructor on instantiation.

=cut

has features => (
    is        => 'ro',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

1;
