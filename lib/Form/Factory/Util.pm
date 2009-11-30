package Form::Factory::Util;
use Moose;

use Sub::Exporter -setup => {
    exports => [ qw(
        class_name_from_name
    ) ],
};

=head1 NAME

Form::Factory::Util - Utility subroutines that don't belong anywhere else

=head1 DESCRIPTION

Utility subroutines that don't belong anywhere else.

=head1 METHODS

=head2 class_name_from_name

  my $class_name = class_name_from_name($name);

Used to build capitalized class names from all lowercase names.

=cut

sub class_name_from_name($) {
    my ($name) = @_;

    $name =~ s/(?:[^A-Za-z]+|^)([A-Za-z])/\U$1/g;
    return ucfirst $name;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
