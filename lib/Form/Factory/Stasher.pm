package FormFactory::Stasher;
use Moose::Role;

requires qw( stash unstash );

=head1 NAME

FormFactory::Stasher - An object responsible for remembering things

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

L<FormFactory::Stasher::Memory>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
