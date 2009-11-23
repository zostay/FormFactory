package FormFactory::Factory;
use Moose::Role;

use FormFactory::Stasher::Memory;
use FormFactory::Util qw( class_name_from_name );

requires qw( render_control consume_control );

=head1 NAME

FormFactory::Factory - Interface for form factory implementations

=head1 SYNOPSIS

  package FormFactory::Factory::MyFactory;
  use Moose;

  with qw( FormFactory::Factory );

  sub render_control {
      my ($self, $control, %options) = @_;

      # Draw $control for user
  }

  sub consume_control {
      my ($self, $control, %options) = @_;

      # Consume values from user to fill $control
  }

=head1 DESCRIPTION

Defines the abstract interface for a form factory. 

=head1 ATTRIBUTES

=head2 stasher

A place for remembering things.

=cut

has stasher => (
    is        => 'ro',
    does      => 'FormFactory::Stasher',
    required  => 1,
    default   => sub { FormFactory::Stasher::Memory->new },
    handles   => [ qw( stash unstash ) ],
);

=head1 METHODS

=head2 stash

=head2 unstash

See L<FormFactory::Stash>.

=head2 new_action

  my $action = $factory->new_action('Some::Action::Class', \%options);

Given the name of an action class, it initializes the class for use with this factory. The C<%options> are passed to the constructor.

=cut

sub new_action {
    my ($self, $class_name, $args) = @_;

    Class::MOP::load_class($class_name)
        or die "cannot load $class_name: $@";

    return $class_name->new( %$args, form_factory => $self );
}

=head2 control_class

  my $class_name = $factory->control_class('full_text');

Returns the control class for the named control.

=cut

sub control_class {
    my ($self, $name) = @_;

    my $class_name = 'FormFactory::Control::' . class_name_from_name($name);

    unless (Class::MOP::load_class($class_name)) {
        warn $@ if $@;
        return;
    }

    return $class_name;
}

=head2 new_control

  my $control = $factory->new_control($name, \%options);

Given the short name for a control and a hash reference of initialization arguments, return a fully initialized control.

=cut

sub new_control {
    my ($self, $name, $args) = @_;

    my $class_name = $self->control_class($name);
    return unless $class_name;

    return $class_name->new($args);
}

=head1 ROLE METHODS

The following methods need to implement the following methods.

=head2 render_control

  $factory->render_control($control, %options);

This method is used to render the control in the current form.

=head2 consume_control

  $factory->consume_control($control, %options);

This method is used to consume the values input for a current form.

=head1 CONTROLS

Here's a list of controls and the classes they represent:

=over

=item button

L<FormFactory::Control::Button>

=item checkbox

L<FormFactory::Control::Checkbox>

=item full_text

L<FormFactory::Control::FullText>

=item password

L<FormFactory::Control::Password>

=item select_many

L<FormFactory::Control::SelectMany>

=item select_one

L<FormFactory::Control::SelectOne>

=item text

L<FormFactory::Control::Text>

=item value

L<FormFactory::Control::Value>

=back

=head1 SEE ALSO

L<FormFactory::Action>, L<FormFactory::Control>, L<FormFactory::Stasher>

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
