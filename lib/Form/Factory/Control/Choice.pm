package FormFactory::Control::Choice;
use Moose;

=head1 NAME

FormFactory::Control::Choice - Helper class for tracking choices

=head1 SYNOPSIS

  my $foo = FormFactory::Control::Choice->new('foo');
  my $bar = FormFactory::Control::Choice->new('bar' => 'Bar');
  my $baz = FormFactory::Control::Choice->new(
      label => 'Baz',
      value => 'baz',
  );
  my $qux = FormFactory::Control::Choice->new({
      label => 'Qux',
      value => 'qux',
  });

=head1 DESCRIPTION

These objects represent a single choice for a list or popup box. Each choice has a label and a value. The constructor is flexible to allow the following uses:

  my $choice = FormFactory::Control::Choice->new($value) # $label = $value
  my $choice = FormFactory::Control::Choice->new($value => $label);
  my $choice = FormFactory::Control::Choice->new(
      label => $label,
      value => $value,
  );
  my $choice = FormFactory::Control::Choice->new({
      label => $label,
      value => $value,
  });

If C<$value> and C<$label> are the same, all of those calls are identical.

=head1 ATTRIBUTES

=head2 label

The label to give the choice.

=cut

has label => (
    is        => 'ro',
    isa       => 'Str',
);

=head2 value

The value of the choice.

=cut

has value => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

sub BUILDARGS {
    my $class = shift;
    my %args;

    if (@_ == 1 and ref $_[0]) {
        %args = %{ $_[0] };
    }
    elsif (@_ == 1) {
        $args{value} = $_[0];
    }
    elsif (@_ == 2) {
        $args{value} = $_[0];
        $args{label} = $_[1];
    }
    else {
        %args = @_;
    }

    $args{label} = $args{value} unless defined $args{label};

    return $class->SUPER::BUILDARGS(%args);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
