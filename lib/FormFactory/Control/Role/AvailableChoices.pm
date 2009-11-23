package FormFactory::Control::Role::AvailableChoices;
use Moose::Role;

use FormFactory::Control::Choice;

has available_choices => (
    is        => 'ro',
    isa       => 'ArrayRef[FormFactory::Control::Choice]',
    required  => 1,
);

1;
