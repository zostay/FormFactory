package Form::Factory::Feature::Role::Control;
use Moose::Role;

use Scalar::Util qw( blessed );

requires qw( check_control );

=head1 NAME

Form::Factory::Feature::Role::Control - Form features tied to particular controls

=head1 SYNOPSIS

  package Form::Factory::Feature::Control::Color;
  use Moose;

  with qw( Form::Factory::Feature Form::Factory::Feature::Role::Control );

  has recognized_colors => (
      is        => 'ro',
      isa       => 'ArrayRef[Str]',
      required  => 1,
      default   => sub { [ qw( red orange yellow green blue purple black white ) ] },
  );

  sub check_control {
      my ($self, $control) = @_;

      die "color feature is only for scalar valued controls"
          unless $control->does('Form::Factory::Control::Role::ScalarValue');
  }

  sub check_value {
      my $self  = shift;
      my $value = $self->control->current_value;

      $self->control_error('the %s does not look like a color')
          unless grep { $value eq $_ } @{ $self->recognized_colors };
  }

And then used in an action via:

  package MyApp::Action::Foo;
  use Form::Factory::Processor;

  has_control favorite_primary_color => (
      control  => 'select_one',
      options  => {
          available_choices => [
              map { Form::Factory::Control::Choice->new($_, ucfirst $_) }
                qw( red yellow blue )
          ],
      },
      features => {
          color => {
              recognized_colors => [ qw( red yellow blue ) ],
          },
      },
  );

=head1 DESCRIPTION

This role is required for any feature attached directly to a control using C<has_control>.

=head1 ATTRIBUTES

=head2 control

This is the control object the feature has been attached to.

=cut

has control => (
    is          => 'ro',
    does        => 'Form::Factory::Control',
    required    => 1,
    weak_ref    => 1,
    initializer => sub {
        my ($self, $value, $set, $attr) = @_;
        $self->check_control($value);
        $set->($value);
    },
);

=head1 METHODS

=head2 clean

Checks to see if a C<clean_value> method is defined and calls it if it is.

=cut

sub clean {
    my $self = shift;
    $self->clean_value(@_) if $self->can('clean_value');
}

=head2 check

Checks to see if a C<check_value> method is defined and calls it if it is.

=cut

sub check {
    my $self = shift;;
    $self->check_value(@_) if $self->can('check_value');
}

=head2 pre_process

Checks to see if a C<pre_process_value> method is deifned and calls it if it is.

=cut

sub pre_process {
    my $self = shift;
    $self->pre_process_value(@_) if $self->can('pre_process_value');
}

=head2 post_process

Checks to see if a C<post_process_value> method is deifned an calls it if it is.

=cut

sub post_process {
    my $self = shift;
    $self->post_process_value(@_) if $self->can('post_process_value');
}

=head2 format_message

  my $formatted_message = $feature->format_message($unformatted_message);

Given a message containing a single C<%s> placeholder, it fills that placeholder with the control's label. If the control does not implement L<Form::Factory::Control::Role::Labeled>, the control's name is used instead.

=cut

sub format_message {
    my $self    = shift;
    my $message = $self->message || shift;
    my $control = $self->control;

    my $control_label 
        = $control->does('Form::Factory::Control::Role::Labeled') ? $control->label
        :                                                         $control->name
        ;

    sprintf $message, $control_label;
}

=head2 control_info

Reports an informational message automatically filtered through L</format_message>.

=cut

sub control_info {
    my $self    = shift;
    my $message = $self->format_message(shift);
    $self->result->field_info($self->control->name, $message);
}

=head2 control_warning

Reports a warning automatically filtered through L</format_message>.

=cut

sub control_warning {
    my $self = shift;
    my $message = $self->format_message(shift);
    $self->result->field_warning($self->control->name, $message);
}

=head2 control_error

Reports an error automatically filtered through L</format_error>.

=cut

sub control_error {
    my $self = shift;
    my $message = $self->format_message(shift);
    $self->result->field_error($self->control->name, $message);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
