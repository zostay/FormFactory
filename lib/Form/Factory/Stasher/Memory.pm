package FormFactory::Stasher::Memory;
use Moose;

with qw( FormFactory::Stasher );

=head1 NAME

FormFactory::Stasher::Memory - Remember things in a Perl hash

=head1 SYNOPSIS

  $c->session->{stash_stuff} ||= {};
  my $stasher = FormFactory::Stasher::Memory->new(
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

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
