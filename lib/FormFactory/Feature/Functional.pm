package FormFactory::Feature::Functional;
use Moose;

with qw( FormFactory::Feature );

has cleaner_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

has checker_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

has pre_processor_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

has post_processor_code => (
    is        => 'ro',
    isa       => 'HashRef[CodeRef]',
    required  => 1,
    default   => sub { {} },
);

sub clean {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->cleaner_code };
}

sub check {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->checker_code };
}

sub pre_process {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->pre_processor_code };
}

sub post_process {
    my $self = shift;
    $_->($self->action, @_) for values %{ $self->post_processor_code };
}

1;
