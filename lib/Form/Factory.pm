package Form::Factory;
use Moose;

use Form::Factory::Util qw( class_name_from_name );

=head1 NAME

Form::Factory - a general-purpose form handling API

=head1 SYNOPSIS

  ### CGI, HTML example
  my $interface = Form::Factory->new_interface('HTML');
  my $action  = $interface->new_action('MyApp::Action::Login');

  ### Drawing the form contents
  $action->unstash('login');
  $action->globals->{after_login} = '/index.html';
  $action->stash('login');
  $action->render;
  $action->render_control(button => {
      name  => 'submit',
      label => 'Login',
  });
  $action->results->clear_all;
  
  ### Processing the form result
  my $q = CGI->new;
  $action->unstash('login');
  $action->consume_and_clean_and_check_and_process( request => $q->Vars );

  if ($action->is_valid and $action->is_success) {
      $action->stash('login');
      print $q->redirect($action->globals->{after_login});
  }
  else {
      print q{<p class="errors">};
      print $action->error_messages;
      print q{</p>};
  }

=head1 DESCRIPTION

B<ALPHA API>. This code is not fully tested (if you look in the test files you will see a long list of tests planned, but no yet implemented). It is currently being employed on a non-production project. The API I<will> change. See L</TODO> for more.

This API is designed to be a general purpose API for showing and processing forms. This has been done before. I know. However, I believe this provides some distinct advantages. However, you should definitely check out the alternatives because this might be more complex than you really need.

That said, why would you want this?

=head2 MODULAR AND EXTENSIBLE

This forms process makes heavy use of L<Moose>. Nearly every class is replaceable or extensible in case it does not work the way you need it to. It is initially implemented to support HTML forms, but I would like to see it support XForms, XUL, PDF forms, GUI forms via Wx or Curses, command-line interfaces, etc.

=head2 ENCAPSULATED ACTIONS

The centerpiece of this API is the way an action is encapsulated in a single object. In a way, a form object is a glorified functor with a C<run> method responsible for taking the action. Wrapped around that is the ability to describe what kind of input is expected, how to clean up and verify the input, how to report errors so that they can be used, how entered values can be sent back to the orignal user, etc.

The goal here is to create self-contained actions that specify what they are in fairly generic terms, take specific action when the input checks out, to handle exceptions in a way that is convenient in forms processing (where exceptions are often more common than not) and send back output cleanly.

=head2 MULTIPLE IMPLEMENTATIONS

An action presents a blueprint for the data it needs to work. A form interface takes that blueprint and builds the UI to present the user and consume the input from the user to present back to the action.

As mentioned above, a form interface could be any kind of UI. The way the form interface and action is used will depend on the form interface implementation, but the action itself should not need to care overmuch about that. It might specify something related to a specific interface, but it would still work with a different interface anyway.

=head2 CONTROLS VERSUS WIDGETS

We specifically separate the logic for specifying controls from the widgets implementing those controls. A control specifies that the action expects some user input and a description of how that data is expected. The widget then implements that using whatever form control is most appropriate.

=head2 FORM FEATURES

Forms and controls can be extended with common features. These features can clean up the input, check the input for errors, and provide additional processing to forms. Features can be added to an action class or even to a specific instance to modify the form on the fly.

=head1 METHODS

=head2 new_interface

  my $interface = Form::Factory->new_interface($name, \%options);

This creates a L<Form::Factory::Interface> object with the given options. This is, more or less, a shortcut for:

  my $interface_class = 'Form::Factory::Interface::' . $name;
  my $interface       = $interface_class->new(\%options);

=cut

sub new_interface {
    my $class = shift;
    my $name  = shift;
    my $class_name = 'Form::Factory::Interface::' . $name;
    unless (Class::MOP::load_class($class_name)) {
        die $@ if $@;
        die "cannot load form interface $class_name";
    }
    return $class_name->new(@_);
}

=head2 control_class

  my $class_name = Form::Factory->control_class('full_text');

Returns the control class for the named control.

=cut

sub control_class {
    my $name = $_[1];

    my $class_name = 'Form::Factory::Control::' . class_name_from_name($name);

    unless (Class::MOP::load_class($class_name)) {
        warn $@ if $@;
        return;
    }

    return $class_name;
}

=head1 TODO

This is not definite, but some things I know as of right now I'm not happy with:

=over

=item *

There are lots of tweaks coming to controls, especially L<Form::Factory::Control::Button>. I'm not very happy with how this is done right now, so something will change.

=item *

Features do not do very much yet, but they must do more, especially control features. I want features to be able to modify control construction, add interface-specific functionality for rendering and consuming, etc. They will be bigger and badder, but this might mean who knows what needs to change elsewhere.

=item *

The interfaces are kind of stupid at this point. They probably need a place to put their brains so they can some more interesting work.

=back

=head1 CODE REPOSITORY

If you would like to take a look at the latest progress on this software, please see the Github repository: L<http://github.com/zostay/FormFactory>

=head1 BUGS

Please report any bugs you find to the Github issue tracker: L<http://github.com/zostay/FormFactory/issues>

If you need help getting started or something (the documentation was originally thrown together over my recent vacation, so it's probably lacking and wonky), you can also contact me on Twitter (L<http://twitter.com/zostay>) or by L<email|/AUTHOR>.

=head1 SEE ALSO

L<Form::Factory::Interface::CLI>, L<Form::Factory::Interface::HTML>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
