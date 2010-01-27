use Test::Able::Runner;
use Form::Factory;

if ($ENV{TEST_PACKAGE}) {
    use_test_packages 
        -test_packages => [ 'Form::Factory::Test::' . $ENV{TEST_PACKAGE} ];
}

else {
    use_test_packages
        -test_packages => [ qw(
            Form::Factory::Test::Action::AllControls
            Form::Factory::Test::Action::Basic
            Form::Factory::Test::Action::Controls
            Form::Factory::Test::Action::Inheritance
            Form::Factory::Test::CustomClassNames
            Form::Factory::Test::Feature::Control::BuildControl
            Form::Factory::Test::Feature::Control::FillOnAssignment
            Form::Factory::Test::Feature::Control::Length
            Form::Factory::Test::Feature::Control::Required
            Form::Factory::Test::Feature::Control::Trim
            Form::Factory::Test::Feature::RequireNoneOrAll
            Form::Factory::Test::Interface::CLI
            Form::Factory::Test::Interface::HTML
            Form::Factory::Test::Result::Gathered
            Form::Factory::Test::Result::Single
        ) ];
}

run;

__END__

=head1 TODO

I have not gotten nearly all the tests I want written done. Here is a list of tests I intend to write but haven't (as of this writing):

=head2 Form::Factory::Test::Action::Basic

Testing that the stash/unstash are used correctly.

Test render.

Test render_control.

=head2 Form::Factory::Test::Action::Inheritance

Test to make sure that actions cope with inheritance correctly.

=head2 Form::Factory::Test::Action::RoleComposition

Test to make sure that acitons cope with role composition correctly.

=head2 Form::Factory::Test::Interface::HTML

Make sure it renders each control (properly).

=head2 Form::Factory::Test::Control::Button

=head2 Form::Factory::Test::Control::Checkbox

=head2 Form::Factory::Test::Control::FullText

=head2 Form::Factory::Test::Control::Password

=head2 Form::Factory::Test::Control::SelectMany

=head2 Form::Factory::Test::Control::SelectOne

=head2 Form::Factory::Test::Control::Text

=head2 Form::Factory::Test::Control::Value

=head2 Form::Factory::Test::Feature::Control::Length

=head2 Form::Factory::Test::Feature::Control::MatchAvailableChoices

=head2 Form::Factory::Test::Feature::Control::MatchCode

=head2 Form::Factory::Test::Feature::Control::MatchRegex

=head2 Form::Factory::Test::Feature::Control::Required

=head2 Form::Factory::Test::Feature::Control::Trim

=head2 Form::Factory::Test::Message

=head2 Form::Factory::Test::Result::Single

=head2 Form::Factory::Test::Result::Gathered

=head2 Form::Factory::Test::Stasher::Memory

=cut

