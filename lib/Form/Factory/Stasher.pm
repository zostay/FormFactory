package Form::Factory::Stasher;

use Moose::Role;

requires qw( stash unstash );

# ABSTRACT: An object responsible for remembering things

=head1 DESCRIPTION

A stasher remembers things.

=head1 ROLE METHODS

=head2 stash

  $stasher->stash($key, $hashref);

Given a C<$key> to store it under and a C<$hashref> to store. Remember the given information for recall with L</unstash>.

=head2 unstash

  my $hashref = $stasher->unstash($key);

Given a C<$key>, recall a previously stored C<$hashref>.

=head1 SEE ALSO

L<Form::Factory::Stasher::Memory>

=cut

1;
