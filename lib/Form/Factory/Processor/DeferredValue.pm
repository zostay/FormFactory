package Form::Factory::Processor::DeferredValue;
use Moose;

=head1 NAME

Form::Factory::Processor::DeferredValue - Tag class for deferred_values

=head1 DESCRIPTION

No user serviceable parts. You void your non-existant warranty if you open this up.

See L<Form::Factory::Processor/deferred_value>. There's really nothing to see here.

=cut

has code => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
);

=head1 SEE ALSO

L<Form::Factory::Processor>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
