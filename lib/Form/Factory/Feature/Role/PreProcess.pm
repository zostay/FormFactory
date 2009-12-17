package Form::Factory::Feature::Role::PreProcess;
use Moose::Role;

requires qw( pre_process );

=head1 NAME

Form::Factory::Feature::Role::PreProcess - features that run just before processing

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

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
