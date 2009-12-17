package Form::Factory::Feature::Role::Check;
use Moose::Role;

requires qw( check );

=head1 NAME

Form::Factory::Feature::Role::Check - features that check control values

=head1 SYNOPSIS

  package MyApp::Feature::Bar;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::Check
  );

  sub check {
      my $self = shift;

      # Check the value for errors, it must contain Bar
      my $value = $self->control->{something}->current_value;
      unless ($value =~ /\bBar\b/) {
          $self->result->error('control must contain Bar');
          $self->result->is_valid(0);
      }
      else {
          $self->result->is_valid(1);
      }
  }

  package Form::Factory::Feature::Custom::Bar;
  sub register_implementation { 'MyApp::Feature::Bar' }

=head1 DESCRIPTION

Features that check the correctness of control values implement this role. This runs after input has been consumed and cleaned and before it is processed. The check here is meant to verify whether the input is valid and ready for processing. Mark the result as invalid to prevent processing. In general, it's a good idea to return an error if you do that. This is also a good place to return warnings.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
