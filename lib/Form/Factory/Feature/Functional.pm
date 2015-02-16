package Form::Factory::Feature::Functional;

use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Clean
    Form::Factory::Feature::Role::Check
    Form::Factory::Feature::Role::PreProcess
    Form::Factory::Feature::Role::PostProcess
);

=head1 NAME

Form::Factory::Feature::Functional - A generic feature for actions

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use Form::Factory::Processor;

  has_cleaner squeaky => sub {
      my $action = shift;
      # clean up the action input here...
  };

  has_checker black_or_read => sub {
      my $action = shift;
      # check the action input here... 
  };

  has_pre_processor remember_cpp => sub {
      my $action = shift;
      # run code just before processing here...
  };

  has_post_processor industrial_something => sub {
      my $action = shift;
      # run code just after processing here...
  };

=head1 DESCRIPTION

You probably don't want to use this feature directly. The various helpers imported when you use L<Form::Factory::Processor> actually use this feature for implementation. You probably want to use those instead.

=head1 ATTRIBUTES

=head2 cleaner_code

An array of subroutines to run during the clean phase.

=cut

has cleaner_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

=head2 checker_code

An array of subroutines to run during the check phase.

=cut

has checker_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

=head2 pre_processor_code

An array of subroutines to run during the pre-process phase.

=cut

has pre_processor_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

=head2 post_process_code

An array of subroutines to run during the post-process phase.

=cut

has post_processor_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

=head1 METHODS

=head2 clean

Run all the subroutines in L</cleaner_code>.

=cut

sub clean {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->cleaner_code };
}

=head2 check

Run all the subroutines in L</checker_code>.

=cut

sub check {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->checker_code };
}

=head2 pre_process

Run all the subroutines in L</pre_processor_code>.

=cut

sub pre_process {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->pre_processor_code };
}

=head2 post_process

Run all the subroutines in L</post_processor_code>.

=cut

sub post_process {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->post_processor_code };
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
