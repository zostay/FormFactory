package Form::Factory::Stasher::Memory;

use Moose;

with qw( Form::Factory::Stasher );

# ABSTRACT: Remember things in a Perl hash

=head1 SYNOPSIS

  $c->session->{stash_stuff} ||= {};
  my $stasher = Form::Factory::Stasher::Memory->new(
      stash_hash => $c->session->{stash_stuff},
  );

  $stasher->stash(foo => { blah => 1 });
  my $bar = $stasher->unstash('bar');

=head1 DESCRIPTION

Stashes things into a plain memory hash. This is useful if you already have a mechanism for remember things that can be reused via a hash.

=head1 ATTRIBUTES

=head2 stash_hash

The hash reference to stash stuff into. Defaults to an empty anonymous hash.

=cut

has stash_hash => (
    is        => 'rw',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

=head1 METHODS

=head2 stash

Stash the stuff given.

=cut

sub stash {
    my ($self, $moniker, $stash) = @_;
    $self->stash_hash->{ $moniker } = $stash;
}

=head2 unstash

Unstash the stuff requested.

=cut

sub unstash {
    my ($self, $moniker) = @_;
    delete $self->stash_hash->{ $moniker };
}

__PACKAGE__->meta->make_immutable;
