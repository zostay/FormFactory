package Form::Factory::Feature::Control::FillOnAssignment;
use Moose;

with qw(
    Form::Factory::Feature
    Form::Factory::Feature::Role::BuildAttribute
    Form::Factory::Feature::Role::Control
);

use Carp ();

=head1 NAME

Form::Factory::Feature::Control::FillOnAssignment - Control gets the value of the attribute

=head1 SYNOPSIS

  package MyApp::Action::Thing;
  use Form::Factory::Processor;

  has_control title => (
      control   => 'text',
      features  => {
          fill_on_assignment => 1,
      },
  );

  package Somewhere::Else;

  my $interface = Form::Factory->new_interface('HTML');
  my $action = $itnerface->new_action('MyApp::Action::Thing' => {
      title => 'Some preset title',
  });

  $action->render; # outputs an INPUT with value="Some preset title"

  $action->title('A different value');

  $action->render; # outputs an INPUT with value="A different value"

=head1 DESCRIPTION

This feature adds a trigger to the control so that any assignment to the action value causes the control to also gain that value.

=head1 METHODS

=head2 check_control

No op.

=cut

sub check_control { }

=head2 build_attribute

This modifies the attribute being created to have a C<trigger> that causes the default value of the control to gain the value of the action's attribute on set. Unless C<no_warning> is set, this will cause a warning if the "is" setting is not set to "rw".

=cut

sub build_attribute {
    my ($self, $options, $meta, $name, $attr) = @_;

    unless ($options->{no_warning}) {
        Carp::carp("the $name attribute is read-only, but the fill_on_assignment feature is enabled for it, are you sure this is correct?")
            if $attr->{is} eq 'ro' or $attr->{is} eq 'bare';
    }

    $attr->{trigger} = sub {
        my ($self, $value) = @_;
        my $control = $self->controls->{$name};
        $value = $control->convert_value_to_control($value);
        $self->controls->{$name}->default_value($value);
    };
}

=head2 BUILD

After building the feature, this will set the default value of the control to the value currently held by the action attribute.

=cut

sub BUILD {
    my $self    = shift;
    my $action  = $self->action;
    my $control = $self->control;

    my $attr  = $action->meta->find_attribute_by_name($control->name);
    my $value = $attr->get_value($action);

    if (defined $value) {
        $value = $control->convert_value_to_control($value);
        $control->default_value($value);
    }

    return $self;
};

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
