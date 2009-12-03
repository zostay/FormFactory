package Form::Factory::Control::Role::BooleanValue;
use Moose::Role;

=head1 NAME

Form::Factory::Control::Role::BooleanValue - boolean valued controls

=head1 DESCRIPTION

Controls that implement this role have a boolean value. This say much about how that is actually implemented, just that is has a L</true_value> a L</false_value> and then a flag stating whether the true value or false value is currently selected.

=head1 ATTRIBUTES

=head2 true_value

The string value the control should have when the control L</is_true>.

=cut

has true_value => (
    is        => 'ro',
    required  => 1,
    default   => 1,
);

=head2 false_value

The string value the control should have when the control is not L</is_true>.

=cut

has false_value => (
    is        => 'ro',
    required  => 1,
    default   => '',
);

=head2 is_true

Whether or not the control is currently set.

=cut

has is_true => (
    is        => 'rw',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
