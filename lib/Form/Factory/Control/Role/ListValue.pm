package Form::Factory::Control::Role::ListValue;
use Moose::Role;

requires qw( current_values );

=head1 NAME

Form::Factory::Control::Role::ListValue - list-valued controls

=head1 DESCRIPTION

Implemented by control that are multi-values.

=head1 METHODS

=head2 default_isa

List valued controls are "ArrayRef[Str]" by default.

=cut

use constant default_isa => 'ArrayRef[Str]';

=head2 set_attribute_value

  $control->set_attribute_value($action, $attribute);

Sets the value of the action attribute with current value of teh control.

=cut

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;
    $attribute->set_value($action, $self->current_values);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
