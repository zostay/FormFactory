package Form::Factory::Control::Role::ListValue;
use Moose::Role;

with qw( Form::Factory::Control::Role::Value );

excludes qw( 
    Form::Factory::Control::Role::BooleanValue
    Form::Factory::Control::Role::ScalarValue 
);

=head1 NAME

Form::Factory::Control::Role::ListValue - list-valued controls

=head1 DESCRIPTION

Implemented by control that are multi-values.

=head1 METHODS

=head2 default_isa

List valued controls are "ArrayRef[Str]" by default.

=cut

use constant default_isa => 'ArrayRef[Str]';

=head2 current_values

This is a synonym for C<current_value>.

=cut

sub current_values { shift->current_value(@_) }

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
