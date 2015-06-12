package Form::Factory::Control::Role::ScalarValue;

use Moose::Role;

excludes qw( 
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::ListValue 
);

# ABSTRACT: scalar valued controls

=head1 DESCRIPTION

Implemented by single scalar valued controls

=head1 METHODS

=head2 default_isa

Scalar valued controls are "Str" by default.

=cut

use constant default_isa => 'Str';

1;
