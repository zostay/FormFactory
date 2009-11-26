package FormFactory::Result;
use Moose::Role;

use FormFactory::Message;

=head1 NAME

FormFactory::Result - Interface for the result classes

=head1 SYNOPSIS

  my $result = $action->results;

  if ($result->is_validated and $result->is_valid) {
      print "Action passed validation.\n";
  }

  if ($result->is_outcome_known and $result->is_success) {
      print "Action successfully processed.\n";
  }

  print "EXTRA INFO: ", $result->content->{extra_info}, "\n";

  print "Messages: ", $result->all_messages, "\n";

=head1 DESCRIPTION

After an action has run in part or in whole, a result class will contain the current state of that sucess or failure.

=head1 METHODS

=head2 is_failure

The opposite of L</is_success>.

=cut

# requires qw(
#     is_valid is_validated
#     is_success is_outcome_known
#     content
#     messages
# );

sub is_failure {
    my $self = shift;
    return not $self->is_success;
}

=head2 all_messages

  my $messages = $result->all_messages;
  my @messages = $result->all_messages;

Returns all messages. When a scalar is expected, it returns all messages concatenated with a newline between each. When a list is expected, it returns a list of L<FormFactory::Message> objects.

=cut

sub _return(&@) {
    my ($filter, @messages) = @_;
    
    my @filtered = grep { $filter->() } @messages;
    return wantarray ? @filtered : join "\n", @filtered;
}

sub all_messages {
    my $self = shift;
    return _return { 1 } @{ $self->messages };
}

=head2 info_messages

  my $messages = $result->info_messages;
  my @messages = $result->info_messages;

Returns all mesages with type info. Handles context the same as L</all_messages>.

=cut

sub info_messages {
    my $self = shift;
    return _return { $_->type eq 'info' } @{ $self->messages };
}

=head2 warning_messages

  my $messages = $result->warning_messages;
  my @messages = $result->warning_messages;

Returns all messages with type warning. Handles context the same as L</all_messages>.

=cut

sub warning_messages {
    my $self = shift;
    return _return { $_->type eq 'warning' } @{ $self->messages };
}

=head2 error_messages

  my $messages = $result->error_messages;
  my @messages = $result->error_messages;

Returns all messages with type error. Handles context the same as L</all_messages>.

=cut

sub error_messages {
    my $self = shift;
    return _return { $_->type eq 'error' } @{ $self->messages };
}

=head2 regular_messages

  my $messages = $result->regular_messages;
  my @messages = $result->regular_messages;

Returns all messages that are not tied to a field. Handles context the same as L</all_messages>.

=cut

sub regular_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field } @{ $self->messages };
}

=head2 regular_info_messages

  my $messages = $result->regular_info_messages;
  my @messages = $result->regular_info_messages;

Returns all messages with type info that are not tied to a field. Handles context the same as L</all_messages>.

=cut

sub regular_info_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'info' } 
               @{ $self->messages };
}

=head2 regular_warning_messages

  my $messages = $result->regular_warning_messages;
  my @messages = $result->regular_warning_messages;

Returns all messages with type warning that are not tied to a feild. Handles context the same as L</all_messages>.

=cut

sub regular_warning_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'warning' }
               @{ $self->messages };
}

=head2 regular_error_messages

  my $messages = $result->regular_error_messages;
  my @messages = $result->regular_error_messages;

Returns all messages with type error that are not tied to a field. Handles context the same as L</all_messages>.

=cut

sub regular_error_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'error' } 
               @{ $self->messages };
}

=head2 field_messages

  my $messages = $result->field_messages($field);
  my @messages = $result->field_messages($field);

Returns all messages that are tied to a particular field. Handles context the same as L</all_messages>.

=cut

sub field_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field } 
               @{ $self->messages };
}

=head2 field_info_messages

  my $messages = $result->field_info_messages($field);
  my @messages = $result->field_info_messages($field);

Returns all messages with type info that are tied to a particular field. Handles context the same as L</all_messages>.

=cut

sub field_info_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'info'} 
               @{ $self->messages };
}

=head2 field_warning_messages

  my $messages = $result->field_warning_messages($field);
  my @messages = $result->field_warning_messages($field);

Returns all messages with type warning tied to a particular field. Handles context the same as L</all_messages>.

=cut

sub field_warning_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'warning'} 
               @{ $self->messages };
}

=head2 field_error_messages

  my $messages = $result->field_error_messages($field);
  my @messages = $result->field_error_messages($field);

Returns all messages with type error tied to a particular field. Handles context the same as L</all_messages>.

=cut

sub field_error_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'error'} 
               @{ $self->messages };
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
