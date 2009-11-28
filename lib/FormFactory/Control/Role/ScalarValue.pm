package FormFactory::Control::Role::ScalarValue;
use Moose::Role;

requires qw( current_value );

=head1 NAME

FormFactory::Control::Role::ScalarValue - scalar valued controls

=head1 DESCRIPTION

Implemented by single scalar valued controls

=head1 METHODS

=head2 default_isa

Scalar valued controls are "Str" by default.

=cut

use constant default_isa => 'Str';

=head2 set_attribute_value

  $control->set_attribute_value($action, $attribute);

Sets the action attribute to the current value.

=cut

sub set_attribute_value {
    my ($self, $action, $attribute) = @_;
    $attribute->set_value($action, $self->current_value);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
