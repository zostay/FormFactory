package FormFactory::Action::Meta::Class;
use Moose::Role;

=head1 NAME

FormFactory::Action::Meta::Class - The meta-class for form actions

=head1 SYNOPSIS

  package MyApp::Action::Foo;
  use FormFactory::Processor;

=head1 DESCRIPTION

All form actions have this role attached to its meta-class.

=head1 ATTRIBUTES

=head2 features

This is a hash of features. The keys are the short name of the feature to attach and the value is a hash of options ot pass to the feature's constructor on instantiation.

=cut

has features => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    default  => sub { {} },
);

=head1 METHODS

=head2 get_controls

  my @attributes = $action->meta->get_controls(@names);

Returns all the controls for this action. This includes controls inherited from parent classes as well. This returns a list of attributes which do L<FormFactory::Action::Meta::Attribute::Control>.

You may pass a list of control names if you only want a subset of the available controls. If no list is given, all controls are returned.

=cut

sub get_controls {
    my ($meta, @control_names) = @_;
    my @controls;

    if (@control_names) {
        @controls = grep { $_ } map { $meta->get_attribute($_) } @control_names;
    }

    else {
        @controls = $meta->get_all_attributes;
    }

    @controls = sort { $a->placement <=> $b->placement }
                grep { $_->does('FormFactory::Action::Meta::Attribute::Control') } 
                       @controls;
}

=head2 get_all_features

  my $features = $action->meta->get_all_features;

Returns all the feature specs for teh form. This includes all inherited features as well. These are returned in the same format as the L</features> attribute.

=cut

sub get_all_features {
    my $meta = shift;

    my %all_features;
    for my $class (reverse $meta->linearized_isa) {
        my $other_meta = $meta->initialize($class);

        next unless $other_meta->can('meta');
        next unless $other_meta->meta->can('does_role');
        next unless $other_meta->meta->does_role('FormFactory::Action::Meta::Class');

        %all_features = (%{ $other_meta->features }, %all_features);
    }

    return \%all_features;
}

=head1 SEE ALSO

L<FormFactory::Action>, L<FormFactory::Control>, L<FormFactory::Feature>, L<FormFactory::Processor>

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
