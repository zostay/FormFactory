package Form::Factory::Action::Role;

use Moose::Role;

use Carp ();

=head1 NAME

Form::Factory::Action::Role - Role implemented by action roles

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use Form::Factory::Processor::Role;

  has_control bar => (
      type => 'text',
  );

=head1 DESCRIPTION

This is the role implemented by all form action roles. Do not use this directly, but use L<Form::Factory::Processor::Role>, which performs the magic required to make your class implement this role.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
