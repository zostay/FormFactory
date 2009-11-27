package FormFactory::Test;
use Test::Able;

use FormFactory;

has test_packages => (
    is        => 'ro',
    isa       => 'ArrayRef[Str]',
    required  => 1,
    default   => sub { [ qw(
        FormFactory::Test::Action
        FormFactory::Test::Factory::HTML
    ) ] },
);

sub setup_tests {
    my $self = shift;

    my @test_objects;
    PACKAGE: for my $test_package (@{ $self->test_packages }) {
        unless (Class::MOP::load_class($test_package)) {
            warn $@ if $@;
            warn "FAILED TO LOAD $test_package. Skipping.";
            next PACKAGE;
        }

        push @test_objects, $test_package->new;
    }

    return \@test_objects;
}

before run_tests => sub {
    my $self = shift;
    $self->meta->test_objects($self->setup_tests);
};

1;
