package FormFactory::Feature::Role::Control;
use Moose::Role;

use Scalar::Util qw( blessed );

requires qw( check_control );

has control => (
    is          => 'ro',
    does        => 'FormFactory::Control',
    required    => 1,
    weak_ref    => 1,
    initializer => sub {
        my ($self, $value, $set, $attr) = @_;
        $self->check_control($value);
        $set->($value);
    },
);

sub clean {
    my $self = shift;
    $self->clean_value(@_) if $self->can('clean_value');
}

sub check {
    my $self = shift;;
    $self->check_value(@_) if $self->can('check_value');
}

sub pre_process {
    my $self = shift;
    $self->pre_process_value(@_) if $self->can('pre_process_value');
}

sub post_process {
    my $self = shift;
    $self->post_process_value(@_) if $self->can('post_process_value');
}

sub format_message {
    my $self    = shift;
    my $message = $self->message || shift;
    my $control = $self->control;

    my $control_label 
        = $control->does('FormFactory::Control::Role::Labeled') ? $control->label
        :                                                          $control->name
        ;

    sprintf $message, $control_label;
}

sub control_info {
    my $self    = shift;
    my $message = $self->format_message(shift);
    $self->result->field_info($self->control->name, $message);
}

sub control_warning {
    my $self = shift;
    my $message = $self->format_message(shift);
    $self->result->field_warning($self->control->name, $message);
}

sub control_error {
    my $self = shift;
    my $message = $self->format_message(shift);
    $self->result->field_error($self->control->name, $message);
}

1;
