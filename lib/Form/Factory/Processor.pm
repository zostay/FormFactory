package Form::Factory::Processor;
use Moose;
use Moose::Exporter;

use Form::Factory::Action;
use Form::Factory::Action::Meta::Class;
use Form::Factory::Action::Meta::Attribute::Control;
use Form::Factory::Processor::DeferredValue;

Moose::Exporter->setup_import_methods(
    as_is     => [ qw( deferred_value ) ],
    with_meta => [ qw(
        has_control
        has_cleaner has_checker has_pre_processor has_post_processor
    ) ],
    also      => 'Moose',
);

=head1 NAME

Form::Factory::Processor - Moos-ish helper for action classes

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use Form::Factory::Processor;

  has_control name => (
      control => 'text',
      options => {
          label => 'Your Name',
      },
      features => {
          trim     => 1,
          required => 1,
          length   => {
              minimum => 3,
              maximum => 15,
          },
      },
  );

  has_cleaner convert_to_underscores => sub {
      my $self = shift;
      my $name = $self->controls->{name}->current_value;
      $name =~ s/\W+/_/g;
      $self->controls->{name}->current_value($name);
  };

  has_checker do_not_car_for_names_start_with_r => sub {
      my $self = shift;
      my $value = $self->controls->{name}->current_value;

      $self->error('i do not like names start with "R," get a new name')
          if $value =~ /^R/i;
  };

  has_pre_processor log_start => sub {
      my $self = shift;
      MyApp->logger->debug("START Foo " . Time::HiRes::time());
  };

  has_post_processor log_stop => sub {
      my $self = shift;
      MyApp->logger->debug("STOP Foo " . Time::HiRes::time());
  };

  sub run {
      my $self = shift;
      MyApp->do_something_to_your_name($self->name);
  }

=head1 DESCRIPTION

This is the helper class used to define actions. This class automatically imports the subroutines described in this documentaiton as well as any defined in L<Moose>. It also grants your action class and its meta-class the correct roles.

=head1 METHODS

=head2 init_meta

Sets up the roles and meta-class information for your action class.

=cut

sub init_meta {
    my $package = shift;
    my %options = @_;

    Moose->init_meta(%options);

    my $meta = Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $options{for_class},
        metaclass_roles => [ 'Form::Factory::Action::Meta::Class' ],
    );

    Moose::Util::apply_all_roles(
        $options{for_class}, 'Form::Factory::Action',
    );

    return $meta;
}

=head2 has_control

  has_control $name => (
      %usual_has_options,

      control  => $control_short_name,
      options  => \%control_options,
      features => \%control_features,
  );

This works very similar to L<Moose/has>. This also applies the L<Form::Factory::Action::Meta::Attribute::Control> trait to the attribute and sets up other defaults.

The following defaults are set:

=over

=item is

Control attributes are read-only by default.

=item isa

Control attributes are string by default. Be careful about using an C<isa> setting that differs from the control's value. If you do, make sure you use features to make certain the type is the correct kind of thing or that a coercion to the correct type of thing is also setup.

=item control

This will default to "text" if not set.

=item options

An empty hash reference is used by default.

=item features

An empty hash references is used by default.

=back

=cut

sub has_control {
    my $meta = shift;
    my $name = shift;
    my $args = @_ == 1 ? shift : { @_ };

    $args->{control}  ||= 'text';
    $args->{options}  ||= {};
    $args->{features} ||= {};
    $args->{traits}   ||= [];

    $args->{is}       ||= 'ro';
    $args->{isa}      ||= Form::Factory->control_class($args->{control})->default_isa;

    for my $value (values %{ $args->{features} }) {
        $value = {} unless ref $value;
    }

    unshift @{ $args->{traits} }, 'Form::Control';

    $meta->add_attribute( $name => $args );
}

=head2 deferred_value

  has_control publish_on => (
      control => 'text',
      options => {
          default_value => deferred_value {
              my ($action, $control_name) = @_;
              DateTime->now->iso8601,
          },
      },
  );

This is a helper for deferring the calculation of a value. This works similar to L<Scalar::Defer> to defer the calculation, but with an important difference. The subroutine is passed the action object (such as it exists while the controls are being constructed) and the control's name. The control itself doesn't exist yet when the subroutine is called.

=cut

sub deferred_value(&) {
    my $code = shift;

    return Form::Factory::Processor::DeferredValue->new(
        code => $code,
    );
}

=head2 has_cleaner

  has_cleaner $name => sub { ... }

Adds some code called during the clean phase.

=head2 has_checker

  has_checker $name => sub { ... }

Adds some code called during the check phase.

=head2 has_pre_processor

  has_pre_processor $name => sub { ... }

Adds some code called during the pre-process phase.

=head2 has_post_processor

  has_post_processor $name => sub { ... }

Adds some code called during the post-process phase.

=cut

sub _add_feature {
    my ($type, $meta, $name, $code) = @_;
    die "bad code given for $type $name" unless defined $code;
    $meta->features->{functional}{$type . '_code'}{$name} = $code;
}

sub has_cleaner        { _add_feature('cleaner', @_) }
sub has_checker        { _add_feature('checker', @_) }
sub has_pre_processor  { _add_feature('pre_processor', @_) }
sub has_post_processor { _add_feature('post_processor', @_) }

=head1 SEE ALSO

L<Form::Factory::Action>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
