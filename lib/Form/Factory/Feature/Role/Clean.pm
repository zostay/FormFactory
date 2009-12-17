package Form::Factory::Feature::Role::Clean;
use Moose::Role;

requires qw( clean );

=head1 NAME

Form::Factory::Feature::Role::Clean - features that clean up control values

=head1 SYNOPSIS

  package MyApp::Feature::Foo;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::Clean
  );

  sub clean {
      my $self = shift;

      # Clean up the value, replace it with Foo
      $self->control->{something}->current_value('Foo');
  }

  package Form::Factory::Feature::Foo;
  sub register_implementation { 'MyApp::Feature::Foo' }

=head1 DESCRIPTION

This is for features that run during the clean phase. This runs immediately after the input has been consumed and before it is checked. These features should avoid reporting errors. The intention is for these features to clean up the input automatically before it is checked for errors. This should work with the control values rather than the action attributes directly, since those won't be set yet.

It is possible for the C<clean> method to stop processing by marking the result as invalid, but it is better to do that using L<Form::Factory::Feature::Role::Clean>.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
