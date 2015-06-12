package Form::Factory::Control::Role::AvailableChoices;

use Moose::Role;

use Form::Factory::Control::Choice;

# ABSTRACT: Controls that list available choices

=head1 DESCRIPTION

Controls that have a list of possible options to select from may implement this role.

=head1 ATTRIBUTES

=head2 available_choices

The list of L<Form::Factory::Control::Choice> objects.

=cut

has available_choices => (
    is        => 'ro',
    isa       => 'ArrayRef[Form::Factory::Control::Choice]',
    required  => 1,
);

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
