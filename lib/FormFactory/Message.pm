package FormFactory::Message;
use Moose;

use Moose::Util::TypeConstraints;

has field => (
    is       => 'rw',
    isa      => 'Str',
    predicate => 'is_tied_to_field',
);

has message => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

enum MessageType => qw( info warning error );

has type => (
    is       => 'rw',
    isa      => 'MessageType',
    required => 1,
    default  => 'info',
);

sub english_message {
    my $self = shift;
    my $message = ucfirst $self->message;
    $message .= '.' if $message =~ /(?:[\w\s])$/;
    return $message;
}

1;
