package Form::Factory::Feature::Role::CustomMessage;

use Moose::Role;

=head1 NAME

Form::Factory::Feature::Role::CustomMessage - features with custom messages

=head1 DESCRIPTION

A feature may consume this role in order to allow the user to specify a custom message on failure.

=head1 ATTRIBUTES

=head2 message

This is a custom error message for failures. This message is used instead of the one the feature specifies when L</feature_info>, L</feature_warning>, and L</feature_error> are called.

This is inadequate. It should be fixed in the future.

=cut

has message => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_message',
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
