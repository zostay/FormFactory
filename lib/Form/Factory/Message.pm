package Form::Factory::Message;
use Moose;

use Moose::Util::TypeConstraints;
enum 'Form::Factory::Message::Type' => [qw( info warning error )];
no Moose::Util::TypeConstraints;

=head1 NAME

Form::Factory::Message - Handy class for encapsulating messages

=head1 SYNOPSIS

  my $message = Form::Factory::Message->new(
      field   => 'foo',
      type    => 'warning',
      message => 'Blah blah blah',
  );

  if ($message->type eq 'warning' or $message->type eq 'error') {
      print uc($message->type);
  }

  if ($message->is_tied_to_field) {
      print $message->field, ": ", $message->message, "\n";
  }

=head1 DESCRIPTION

This is used to store messages that describe the outcome of the various parts of the action workflow.

=head1 ATTRIBUTES

=head2 field

This is the name of the field the message belongs with. If set the C<is_tied_to_field> predicate will return true.

=cut

has field => (
    is       => 'rw',
    isa      => 'Str',
    predicate => 'is_tied_to_field',
);

=head2 message

This is the message itself. By convention, the message is expected to be formatted with the initial caps left off and no ending punctuation. This allows it to be more easily formatted or embedded into larger error messages, if necessary.

=cut

has message => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

=head2 type

This is the type of message. Must be one of: info, warning, or error.

=cut

has type => (
    is       => 'rw',
    isa      => 'Form::Factory::Message::Type',
    required => 1,
    default  => 'info',
);

=head1 METHODS

=head2 english_message

This capitalizes the first character of the message and adds a period at the end of the last character is a word or space character.

=cut

sub english_message {
    my $self = shift;
    my $message = ucfirst $self->message;
    $message .= '.' if $message =~ /(?:[\w\s])$/;
    return $message;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
