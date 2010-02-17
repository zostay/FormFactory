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

=cut

has '+value' => (
    isa       => 'Str',
);

has '+default_value' => (
    isa       => 'Str',
    default   => '',
);

=head1 METHODS

=head2 has_current_value

We have a current value if it is defined and has a non-zero string length.

=cut

around has_current_value => sub {
    my $next = shift;
    my $self = shift;

    return ($self->has_value || $self->has_default_value)
        && length($self->current_value) > 0;
};

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
