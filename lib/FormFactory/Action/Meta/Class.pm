package FormFactory::Action::Meta::Class;
use Moose::Role;

has features => (
    is       => 'ro',
    isa      => 'ArrayRef[HashRef]',
    required => 1,
    default  => sub { [] },
);

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

sub get_all_features {
    my $meta = shift;

    my @features;
    for my $class (reverse $meta->linearized_isa) {
        my $other_meta = $meta->initialize($class);

        next unless $other_meta->can('meta');
        next unless $other_meta->meta->can('does_role');
        next unless $other_meta->meta->does_role('FormFactory::Action::Meta::Class');

        push @features, @{ $other_meta->features };
    }

    return \@features;
}

1;
