package FormFactory::Result;
use Moose::Role;

use FormFactory::Message;

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

sub _return(&@) {
    my ($filter, @messages) = @_;
    
    my @filtered = grep { $filter->() } @messages;
    return wantarray ? @filtered : join "\n", @filtered;
}

sub all_messages {
    my $self = shift;
    return _return { 1 } @{ $self->messages };
}

sub info_messages {
    my $self = shift;
    return _return { $_->type eq 'info' } @{ $self->messages };
}

sub warning_messages {
    my $self = shift;
    return _return { $_->type eq 'warning' } @{ $self->messages };
}

sub error_messages {
    my $self = shift;
    return _return { $_->type eq 'error' } @{ $self->messages };
}

sub regular_info_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'info' } 
               @{ $self->messages };
}

sub regular_warning_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'warning' }
               @{ $self->messages };
}

sub regular_error_messages {
    my $self = shift;
    return _return { not $_->is_tied_to_field and $_->type eq 'error' } 
               @{ $self->messages };
}

sub field_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field } 
               @{ $self->messages };
}

sub field_info_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'info'} 
               @{ $self->messages };
}

sub field_warning_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'warning'} 
               @{ $self->messages };
}

sub field_error_messages {
    my ($self, $field) = @_;
    return _return { $_->is_tied_to_field and $_->field eq $field and $_->type eq 'error'} 
               @{ $self->messages };
}

1;
