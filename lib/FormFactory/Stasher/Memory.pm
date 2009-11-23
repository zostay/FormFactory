package FormFactory::Stasher::Memory;
use Moose;

with qw( FormFactory::Stasher );

has stash_hash => (
    is        => 'rw',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

sub stash {
    my ($self, $moniker, $stash) = @_;
    $self->stash_hash->{ $moniker } = $stash;
}

sub unstash {
    my ($self, $moniker) = @_;
    delete $self->stash_hash->{ $moniker };
}

1;
