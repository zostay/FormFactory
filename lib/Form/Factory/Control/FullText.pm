package Form::Factory::Control::FullText;

use Moose;

with qw(
    Form::Factory::Control
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::MultiLine
    Form::Factory::Control::Role::ScalarValue
);

=head1 NAME

Form::Factory::Control::FullText - The full_text control

=head1 SYNOPSIS

  has_control message => (
      control => 'full_text',
      options => {
          default_value => q{Lots of
            text goes
            in here.},
      },
  );

=head1 DESCRIPTION

This is a multi-line text control.

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
