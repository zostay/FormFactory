package Form::Factory::Feature;
use Moose::Role;

use Scalar::Util qw( blessed );

requires qw( clean check pre_process post_process );

=head1 NAME

Form::Factory::Feature - Interface for objects that modify how actions work

=head1 SYNOPSIS

  package MyApp::Feature::Foo;
  use Moose;

  with qw( Form::Factory::Feature );

  sub clean {
      my $self = shift;

      # clean the input...
  }

  sub check {
      my $self = shift;

      # check the input...
  }

  sub pre_process {
      my $self = shift;

      # run before the process...
  }

  sub post_process {
      my $self = shift;

      # run after the process...
  }

=head1 DESCRIPTION

A feature modifies what the form does during processing.

=head1 ATTRIBUTES

=head2 name

The short name of the feature. This is automatically built from the feature's class name.

=cut

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 1,
    default   => sub {
        my $self = shift;
        my $class_name = blessed $self;
        unless ($class_name =~ s/^Form::Factory::Feature::Control:://) {
            $class_name =~ s/^Form::Factory::Feature:://;
        }
        $class_name =~ s/(\p{Lu})/_\l$1/g;
        $class_name =~ s/\W+/_/g;
        $class_name =~ s/_+/_/g;
        $class_name =~ s/^_//;
        return lc $class_name;
    },
);

=head2 action

The action this feature has been attached to.

=cut

has action => (
    is        => 'ro',
    isa       => 'Form::Factory::Action',
    required  => 1,
    weak_ref  => 1,
);

=head2 message

This is a custom error message for failures. This message is used instead of the one the feature specifies when L</feature_info>, L</feature_warning>, and L</feature_error> are called.

This is inadequate. It should be fixed in the future.

=cut

has message => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_message',
);

=head2 result

This is the L<Form::Factory::Result::Single> recording the success or failure of the parts of this feature.

=cut

has result => (
    is        => 'ro',
    isa       => 'Form::Factory::Result::Single',
    required  => 1,
    default   => sub { Form::Factory::Result::Single->new },
);

=head1 METHODS

=head2 feature_info

  $feature->feature_info($message);

Record an info feature message.

=cut

sub feature_info {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->info($message);
}

=head2 feature_warning

  $feature->feature_warning($message);

Record a warning feature message.

=cut

sub feature_warning {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->warning($message);
}

=head2 feature_error

  $feature->feature_error($message);

Record an error feature message.

=cut

sub feature_error {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->error($message);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
