package Form::Factory::Feature::Role::PreProcess;

use Moose::Role;

requires qw( pre_process );

# ABSTRACT: features that run just before processing

=head1 SYNOPSIS

  package MyApp::Feature::Baz;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::PreProcess
  );

  sub pre_process {
      my $self = shift;
      MyApp::Logger->info('Starting to process.');
  }

  package Form::Factory::Feature::Custom::Baz;
  sub register_implementation { 'MyApp::Feature::Baz' }

=head1 DESCRIPTION

Features that run something immediately before the action runs may implement this role. This feature cannot stop the action from running. That must be performed with a L<Form::Factory::Feature::Role::Check>.

=head1 ROLE METHOD

=head2 pre_process

This method is called immediately before the C<run> method is called. It is passed no arguments other than the feature object it is called upon. It's return value is ignored.

This method can be used to prevent the C<run> method from being called by throwing an exception.

=cut

1;
