package Form::Factory::Action::Role;

use Moose::Role;

use Carp ();

# ABSTRACT: Role implemented by action roles

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use Form::Factory::Processor::Role;

  has_control bar => (
      type => 'text',
  );

=head1 DESCRIPTION

This is the role implemented by all form action roles. Do not use this directly, but use L<Form::Factory::Processor::Role>, which performs the magic required to make your class implement this role.

=cut

1;
