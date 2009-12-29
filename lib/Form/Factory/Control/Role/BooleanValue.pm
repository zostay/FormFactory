package Form::Factory::Control::Role::BooleanValue;
use Moose::Role;

with qw( Form::Factory::Control::Role::Value );

excludes qw(
    Form::Factory::Control::Role::ListValue
    Form::Factory::Control::Role::ScalarValue
);

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

=head1 METHODS

=head2 is_true

Returns a true value when the C<current_value> is set to L</true_value> or a false value when the C<current_value> is set to L</false_value>.

This method returns C<undef> if it is neither true nor false.

If passed a value:

  $self->is_true(1);

This will set the C<value> attribute. If a true value is given, the C<value> will be set to L</true_value>. Otherwise, it will cause C<value> to take on the contents of L</false_value>.

=cut

sub is_true {
    my $self = shift;

    if (@_) {
        my $is_true = shift;
        $self->value($is_true ? $self->true_value : $self->false_value);
    }

    # blow off these warnings rather than test for them
    no warnings 'uninitialized'; 

    return 1  if $self->current_value eq $self->true_value;
    return '' if $self->current_value eq $self->false_value;
    return scalar undef;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
