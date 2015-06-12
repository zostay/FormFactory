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

1;
