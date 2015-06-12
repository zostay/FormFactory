package Form::Factory::Feature::Role::PostProcess;

use Moose::Role;

requires qw( post_process );

# ABSTRACT: features that run just after processing

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

=head1 ROLE METHOD

=head2 post_process

This method is called immediately after the C<run> method is called. It is passed no arguments other than the feature object it is called upon. It's return value is ignored.

=cut

1;
