package FormFactory::Feature::Functional;
use Moose;

with qw( FormFactory::Feature );

has name => (
    is        => 'ro',
    isa       => 'Str',
);

has cleaner_code => (
    is        => 'ro',
    isa       => 'CodeRef',
    predicate => 'has_cleaner',
);

has checker_code => (
    is        => 'ro',
    isa       => 'CodeRef',
    predicate => 'has_checker',
);

has pre_processor_code => (
    is        => 'ro',
    isa       => 'CodeRef',
    predicate => 'has_pre_processor',
);

has post_processor_code => (
    is        => 'ro',
    isa       => 'CodeRef',
    predicate => 'has_post_processor',
);

sub clean {
    my $self = shift;
    $self->cleaner_code->($self->action, @_) if $self->has_cleaner;
}

sub check {
    my $self = shift;
    $self->checker_code->($self->action, @_) if $self->has_checker;
}

sub pre_process {
    my $self = shift;
    $self->pre_processor_code->($self->action, @_) if $self->has_pre_processor;
}

sub post_process {
    my $self = shift;
    $self->post_processor_code->($self->action, @_) if $self->has_post_processor;
}

1;
