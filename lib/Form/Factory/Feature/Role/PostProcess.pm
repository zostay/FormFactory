package Form::Factory::Feature::Role::PostProcess;
use Moose::Role;

requires qw( post_process );

=head1 NAME

Form::Factory::Feature::Role::PostProcess - features that run just after processing

=head1 SYNOPSIS

  package MyApp::Feature::Qux;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::PostProcess
  );

  sub post_process {
      my $self = shift;
      MyApp::Logger->info('Ending the process.');
  }

  package Form::Factory::Feature::Custom::Qux;
  sub register_implementation { 'MyApp::Feature::Qux' }

=head1 DESCRIPTION

Features that run something immediately after the action runs may implement this role. This feature will run after the action does whether it succeeds or not. It will not run if an exception is thrown.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
