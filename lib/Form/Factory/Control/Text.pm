package Form::Factory::Control::Text;
use Moose;

with qw( 
    Form::Factory::Control 
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::Text - A single line text field

=head1 SYNOPSIS

  has_control your_name => (
      control => 'text',
      options => {
          label         => 'Your Real Name',
          default_value => 'Thomas Anderson',
      },
  );

=head1 DESCRIPTION

A regular text box.

This control implements L<Form::Factory::Control>, L<Form::Factory::Control::Role::Labeled>, and L<Form::Factory::Control::Role::ScalarValue>.

=head1 ATTRIBUTES

=cut


has '+value' => (
    isa       => 'Str',
);

=head2 default_value

The default value of the control.

=cut

has default_value => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_default_value',
);

=head2 stashable_keys

The L</value> is stashed.

=cut

has '+stashable_keys' => (
    default   => sub { [ qw( value ) ] },
);

=head1 METHODS

=head2 current_value

If the L</value> is set, use that. If the L</default_value> is set use that. Otherwise, return the empty string.

=cut

sub current_value {
    my $self = shift;
    $self->value(shift) if @_;
    return $self->has_value         ? $self->value
         : $self->has_default_value ? $self->default_value
         :                            '';
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
