package FormFactory::Result::Gathered;
use Moose;

use Scalar::Util qw( blessed refaddr );
use List::MoreUtils qw( all any );

with qw( FormFactory::Result );

=head1 NAME

FormFactory::Result::Gathered - A group of results

=head1 SYNOPSIS

  my $result = FormFactory::Result::Gathered->new;
  $result->gather_results($other_result1, $other_result2, $other_result3);

  my @child_results = $result->results;

  $result->clear_messages;
  $result->clear_messages_for_field('foo');
  $result->clear_results;
  $result->clear_all;

  my $validated = $result->is_validated;
  my $valid     = $result->is_valid;

  my $has_outcome = $result->is_outcome_known;
  my $success     = $result->is_success;

  my $messages    = $result->messages;
  my $content     = $result->content;

=head1 DESCRIPTION

This is a collection of results. The results are grouped and collected together in a way that makes sense to the FormFactory API.

=cut

has _results => (
    is       => 'ro',
    isa      => 'HashRef[FormFactory::Result]',
    required => 1,
    default  => sub { {} },
);

=head1 METHODS

=head2 results

  my @results = $self->results;

Returns a list of the results that have been gathered.

=cut

sub results {
    my $self = shift;
    return values %{ $self->_results };
}

=head2 gather_results

  $result->gather_results(@results);

Given one or more result objects, it adds them to the list of results already gathered. These are placed in a set such that no result is added more than once. If a result object was already added, it will not be added again.

=cut

sub gather_results {
    my ($self, @results) = @_;

    my $results = $self->_results;
    for my $result (@results) {
        my $addr = refaddr $result;
        $results->{$addr} = $result;
    }
}

=head2 clear_results

Clears the list of results. L</results> will return an empty list after this is called.

=cut

sub clear_results {
    my $self = shift;
    %{ $self->_results } = ();
}

=head2 clear_messages

Calls the C<clear_messages> method on all results that have been gathered. This will clear messages for all the associated results.

=cut

sub clear_messages {
    my $self = shift;
    $_->clear_messages for $self->results;
}

=head2 clear_messages_for_field

  $result->clear_messagesw_for_field($field);

Calls the C<clear_messages_for_field> method on all results that have been gathered. 

=cut

sub clear_messages_for_field {
    my $self  = shift;
    my $field = shift;

    $_->clear_messages_for_field($field) for $self->results;
}

=head2 clear_all

Clears all messages on the gathered results (via L</clear_message>) and then clears all the results (via L</clear_results>).

=cut

sub clear_all {
    my $self = shift;
    $self->clear_messages;
    $self->clear_results;
}

=head2 is_valid

Tests each result for validity. This will return true if every result returns false for C<is_validated> or returns true for C<is_valid>.

=cut

sub is_valid {
    my $self = shift;
    return all { not $_->is_validated or $_->is_valid } $self->results;
}

=head2 is_validated

Returns true if any result returns true for C<is_validated>.

=cut

sub is_validated {
    my $self = shift;
    return any { $_->is_validated } $self->results;
}

=head2 is_success

Tests each result for success. This will return true if every result returns false for C<is_outcome_known> or true for C<is_success>.

=cut

sub is_success {
    my $self = shift;
    return all { not $_->is_outcome_known or $_->is_success } $self->results;
}

=head2 is_outcome_known

Returns true if any result returns true for C<is_outcome_known>.

=cut

sub is_outcome_known {
    my $self = shift;
    return any { $_->is_outcome_known } $self->results;
}

=head2 messages

Returns a reference to an array of messages. This includes all messages from the gathered results.

=cut

sub messages {
    my $self = shift;
    return [ map { @{ $_->messages } } $self->results ];
}

=head2 content

Performs a shallow merge of all the return value of each result's C<content> method and returns that.

=cut

# Dumb merge
sub content {
    my $self = shift;
    return { map { %{ $_->content } } $self->results };
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
