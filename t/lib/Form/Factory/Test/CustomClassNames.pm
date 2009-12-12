package Form::Factory::Test::CustomClassNames;
use Test::Able;
use Test::More;
use Test::Moose;

use Form::Factory;
use TestApp::Control::Null;
use TestApp::Feature::Null;
use TestApp::Feature::Control::Null;
use TestApp::Interface::Null;

test plan => 1, custom_interface => sub {
    my $interface = Form::Factory->new_interface('Null');
    isa_ok($interface, 'TestApp::Interface::Null');
};

test plan => 1, custom_control => sub {
    my $control = Form::Factory->control_class('null');
    is($control, 'TestApp::Control::Null');
};

test plan => 1, custom_feature => sub {
    my $feature = Form::Factory->feature_class('null');
    is($feature, 'TestApp::Feature::Null');
};

test plan => 1, custom_control_feature => sub {
    my $feature = Form::Factory->control_feature_class('null');
    is($feature, 'TestApp::Feature::Control::Null');
};

1;
