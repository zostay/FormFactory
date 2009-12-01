package Form::Factory::Factory::CLI;
use Moose;

with qw( Form::Factory::Factory );

=head1 NAME

Form::Factory::Factory::CLI - Command-line interface builder for form factory

=head1 SYNOPSIS

  #/usr/bin/perl
  use strict;
  use warnings;

  use Form::Factory;

  my $cli = Form::Factory->new_factory('CLI');
  my $action = $cli->new_action(shift @ARGV);
  
  $action->consume_and_clean_and_check_and_process;

  if ($action->is_valid and $action->is_success) {
      print "done.\n";
  }
  else {
      my $messages = $action->results->all_messages;
      print $messages;
      print "usage: $0 OPTIONS\n\n";
      print "Options:\n";
      $action->render;
  }

=head1 DESCRIPTION

Provides a simple interface for building command-line tools that manipulate actions.

=head1 ATTRIBUTES

=head2 renderer

This is a subroutine responsible for returning the usage parameters back to the user. The default prints to C<STDOUT>.

=cut

has renderer => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
    default   => sub { sub { print @_ } },
);

=head2 get_args

This is a subroutine responsible for return a list of command-line arguments. The default implementation returns a reference to C<@ARGV>.

=cut

has get_args => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
    default   => sub { sub { \@ARGV } },
);

=head2 get_file

This is a subroutine responsible for returning the contents of files used on the command-line. It is passed the factory object and then the name of the file to load. The default implementation slurps up the named file or, in the case of the name begin "-", returns the contents of C<STDIN>.

=cut

has get_file => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
    default   => sub { 
        sub { 
            my ($factory, $name) = @_;
            my $fh;

            if ($name eq '-') {
                $fh = \*STDIN;
            }
            else {
                open $fh, '<', $name or die "cannot read $name: $!\n";
            }

            do { local $/; <$fh> };
        }
    },
);

=head1 METHODS

=head2 render_control

Prints a usage line for each control.

=cut

sub render_control {
    my ($self, $control, %options) = @_;

    return if $control->does('Form::Factory::Control::Role::HiddenValue');

    my $arg;
    if ($control->does('Form::Factory::Control::Role::AvailableChoices')) {
        my @values = map { $_->value } @{ $control->available_choices };
        $arg = '[ ' . join(' | ', @values) . ' ]';
    }
    elsif ($control->does('Form::Factory::Control::Role::BooleanValue')) {
        my @values = ($control->true_value, $control->false_value);
        $arg = '[ ' . join(' | ', @values) . ' ]';
    }
    elsif ($control->does('Form::Factory::Control::Role::PresetValue')) {
        $arg = '';
    }
    elsif ($control->does('Form::Factory::Control::Role::MultiLine')) {
        $arg = 'FILE';
    }
    else {
        $arg = 'TEXT';
    }

    my $description = $control->documentation || '';

    $self->renderer->($self,
        sprintf("    --%-20s %s\n", $control->name . ' '. $arg, $description)
    );
}

=head2 consume_control

Consumes the command-line arguments and files specified on the command-line to fill in the action.

=cut

sub consume_control {
    my ($self, $control, %options) = @_;

    die "CLI factory does not know how to consume values for $control"
        unless $control->does('Form::Factory::Control::Role::ScalarValue')
            or $control->does('Form::Factory::Control::Role::ListValue');

    my @argv = @{ $self->get_args->($self) };
    my ($fetch, @values);
    for my $argv (@argv) {
        if ($fetch) {
            push @values, $argv;
            undef $fetch;
        }

        elsif ($argv eq '--' . $control->name) {
            $fetch++;
        }
    }

    return {} unless @values > 0;

    my $get_value = sub {
        my $value = shift;
        if ($control->does('Form::Factory::Control::Role::MultiLine')) {
            return $self->get_file->($self, $value);
        }
        else {
            return $value;
        }
    };

    if ($control->does('Form::Factory::Control::Role::ScalarValue')) {
        die sprintf("the --%s option should be used only once\n", $control->name)
            if@values > 1;
    
        $control->current_value($get_value->($values[0]));
    }

    else {
        my @result;
        push @result, $get_value->($_) for @values;
        $control->current_values(\@result);
    }
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
