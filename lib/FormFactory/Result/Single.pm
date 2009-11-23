package FormFactory::Result::Single;
use Moose;

with qw( FormFactory::Result );

has is_valid => (
    is       => 'rw',
    isa      => 'Bool',
    predicate => 'is_validated',
);

has is_success => (
    is       => 'rw',
    isa      => 'Bool',
    predicate => 'is_outcome_known',
);

has messages => (
    is       => 'ro',
    isa      => 'ArrayRef[FormFactory::Message]',
    required => 1,
    default  => sub { [] },
);

has content => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    default  => sub { {} },
);

sub add_message {
    my ($self, %params) = @_;
    push @{ $self->messages }, FormFactory::Message->new( %params );
}

sub clear_messages {
    my $self = shift;
    @{ $self->messages } = ();
}

sub clear_messages_for_field {
    my ($self, $field) = @_;

    my @messages = grep { $_->is_tied_to_field and $_->field eq $field } 
                       @{ $self->messages };

    @{ $self->messages } = @messages;
}

sub info {
    my ($self, $message) = @_;
    $self->add_message( message => $message );
}

sub field_info {
    my ($self, $field, $message) = @_;
    $self->add_message( field => $field, message => $message );
}

sub warning {
    my ($self, $message) = @_;
    $self->add_message( type => 'warning', message => $message );
}

sub field_warning {
    my ($self, $field, $message) = @_;
    $self->add_message( type => 'warning', field => $field, message => $message );
}

sub error {
    my ($self, $message) = @_;
    $self->add_message( type => 'error', message => $message );
}

sub field_error {
    my ($self, $field, $message) = @_;
    $self->add_message( type => 'error', field => $field, message => $message );
}

sub success {
    my ($self, $message) = @_;
    $self->is_success(1);
    $self->add_message( type => 'info', message => $message);
}

sub failure {
    my ($self, $message) = @_;
    $self->is_success(0);
    $self->add_message( type => 'error', message => $message);
}

1;
