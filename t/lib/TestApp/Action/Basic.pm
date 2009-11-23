package TestApp::Action::Basic;
use FormFactory::Processor;

my $counter = 0;

has_control name => (
    control => 'text',
);

has_cleaner one => sub {
    my $self = shift;
    $self->result->content->{one} = ++$counter;
};

has_checker two => sub {
    my $self = shift;
    $self->result->content->{two} = ++$counter;
};

has_pre_processor three => sub {
    my $self = shift;
    $self->result->content->{three} = ++$counter;
};

has_post_processor five => sub {
    my $self = shift;
    $self->result->content->{five} = ++$counter;
};

sub run {
    my $self = shift;
    $self->result->content->{four} = ++$counter;
}

1;
