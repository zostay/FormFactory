package Form::Factory::Control::Password;

use Moose;

with qw( 
    Form::Factory::Control 
    Form::Factory::Control::Role::Labeled
    Form::Factory::Control::Role::ScalarValue
);

# ABSTRACT: the password control

=head1 SYNOPSIS

  has_control new_password => (
      control => 'password',
  );

head1 DESCRIPTION

This is a password control. It is similar to a text control, but does not stash anything and has no default value.

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

__PACKAGE__->meta->make_immutable;
