package FormFactory::Test;
use Test::Able;

use FormFactory;

has test_packages => (
    is        => 'ro',
    isa       => 'ArrayRef[Str]',
    required  => 1,
    default   => sub { [ qw(
        FormFactory::Test::Action::Basic
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

=head1 TODO

I have not gotten nearly all the tests I want written done. Here is a list of tests I intend to write but haven't (as of this writing):

=head2 FormFactory::Test::Action::Basic

Rename FormFactory::Test::Action to this. 

Make sure that actions cope with deferred values properly.

=head2 FormFactory::Test::Action::Inheritance

Test to make sure that actions cope with inheritance correctly.

=head2 FormFactory::Test::Action::RoleComposition

Test to make sure that acitons cope with role composition correctly.

=head2 FormFactory::Test::Factory::HTML

Make sure it renders each control (properly).

=head2 FormFactory::Test::Control::Button

=head2 FormFactory::Test::Control::Checkbox

=head2 FormFactory::Test::Control::FullText

=head2 FormFactory::Test::Control::Password

=head2 FormFactory::Test::Control::SelectMany

=head2 FormFactory::Test::Control::SelectOne

=head2 FormFactory::Test::Control::Text

=head2 FormFactory::Test::Control::Value

=head2 FormFactory::Test::Feature::Control::Length

=head2 FormFactory::Test::Feature::Control::MatchAvailableChoices

=head2 FormFactory::Test::Feature::Control::MatchCode

=head2 FormFactory::Test::Feature::Control::MatchRegex

=head2 FormFactory::Test::Feature::Control::Required

=head2 FormFactory::Test::Feature::Control::Trim

=head2 FormFactory::Test::Message

=head2 FormFactory::Test::Result::Single

=head2 FormFactory::Test::Result::Gathered

=head2 FormFactory::Test::Stasher::Memory

=cut

1;
