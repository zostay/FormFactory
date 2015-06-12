package Form::Factory::Control::Role::ListValue;

use Moose::Role;

excludes qw( 
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::ScalarValue 
);

# ABSTRACT: list-valued controls

=head1 DESCRIPTION

Implemented by control that are multi-values.

=head1 METHODS

=head2 default_isa

List valued controls are "ArrayRef[Str]" by default.

=cut

use constant default_isa => 'ArrayRef[Str]';

1;
