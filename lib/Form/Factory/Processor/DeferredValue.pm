package Form::Factory::Processor::DeferredValue;

use Moose;

# ABSTRACT: Tag class for deferred_values

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

=cut

__PACKAGE__->meta->make_immutable;
