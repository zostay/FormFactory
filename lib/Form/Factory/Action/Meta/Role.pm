package Form::Factory::Action::Meta::Role;
use Moose::Role;

=head1 NAME

Form::Factory::Action::Meta::Class - The meta-class role for form action roles

=head1 SYNOPSIS

  package MyApp::Action::Role::Foo;
  use Form::Factory::Processor::Role

=head1 DESCRIPTION

All form action roles have this role attached to its meta-class.

=head1 ATTRIBUTES

=head2 features

This is a hash of features provided by the role. The keys are the short name of the feature to attach and the value is a hash of options to pass to the feature's constructor on instantiation.

=cut

has features => (
    is        => 'ro',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
