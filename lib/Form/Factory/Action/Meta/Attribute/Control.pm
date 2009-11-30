package Moose::Meta::Attribute::Custom::Trait::Form::Control;
sub register_implementation { 'Form::Factory::Action::Meta::Attribute::Control' }

package Form::Factory::Action::Meta::Attribute::Control;
use Moose::Role;

=head1 NAME

Form::Factory::Action::Meta::Attribute::Control - Form control attribute-traits

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use Form::Factory::Processor;

  has_control name => (
      control   => 'text',
      placement => 1,
      options   => {
          label => 'The Name',
      },
      features  => {
          required => 1,
          length   => {
              maximum => '20',
          },
      },
  );

=head1 DESCRIPTION

Any control attribute created with the L<Form::Factory::Processor/has_control> subroutine, will have this trait assigned.

=head1 ATTRIBUTES

=head2 placement

This is the sort order of the controls in an action. Normally, controls will be sorted in the order they appear in the class definition, but this lets you modify that. This is mostly useful when an action is composed of different roles or inherits controls from a parent class. This allows you to order your controls relative to the controls defined in the other classes.

=cut

has placement => (
    is        => 'ro',
    isa       => 'Num',
    required  => 1,
    default   => 0,
);

=head2 control

This is the short name of the control. See L<Form::Factory::Factory/CONTROLS> for a list of built-in controls.

=cut

has control => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => 'text',
);

=head2 options

This is a hash of options to pass to the control constructor.

=cut

has options => (
    is        => 'ro',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

=head2 features

This is a hash of feature definitions to attach ot the control. Each key is the short name of a control-feature to attach. The value is either a "1" to indicate no additional arguments or a hash reference of arguments to pass to the feature's constructor.

=cut

has features => (
    is          => 'ro',
    isa         => 'HashRef[HashRef]',
    required    => 1,
    default     => sub { {} },
);

=head1 SEE ALSO

L<Form::Factory::Processor>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
