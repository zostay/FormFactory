package Form::Factory::Feature::Role::CustomControlMessage;

use Moose::Role;

with qw( Form::Factory::Feature::Role::CustomMessage );

=head1 NAME

Form::Factory::Feature::Role::CustomControlMessage - control features with custom messages

=head1 SYNOPSIS

  has_control foo => (
      control   => 'text',
      features  => {
          match_code => {
              message => 'Foo values must be even',
              code    => sub { $_[0] % 2 == 0 },
          },
      },
  );

=head1 DESCRIPTION

A control feature may consume this role in order to allow the user to specify a custom message on failure. This message may include a single "%s" placeholder, which will be filled in with the label or name of the control.

=head1 METHODS

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
        :                                                           $control->name
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
