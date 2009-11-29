package TestApp::Action::EveryControl;
use FormFactory::Processor;

has_control button => (
    control   => 'button',
    options   => {
        label => 'Foo',
    },
);

has_control checkbox => (
    control   => 'checkbox',
    options   => {
        checked_value   => 'xyz',
        unchecked_value => 'abc',
    },
);

has_control full_text => (
    control   => 'full_text',
);

has_control password  => (
    control   => 'password',
);

has_control select_many => (
    control   => 'select_many',
    options   => {
        available_choices => [
            map { FormFactory::Control::Choice->new($_) } 
              qw( one two three four five )
        ],
    },
);

has_control select_one => (
    control   => 'select_one',
    options   => {
        available_choices => [
            map { FormFactory::Control::Choice->new($_) } 
              qw( ay bee see dee ee )
        ],
    },
);

has_control text => ();

has_control value => (
    control   => 'value',
    options   => {
        value => 'galaxy',
    },
);

sub run {
    my $self = shift;

    $self->result->content->{button}      = $self->button;
    $self->result->content->{checkbox}    = $self->checkbox;
    $self->result->content->{full_text}   = $self->full_text;
    $self->result->content->{password}    = $self->password;
    $self->result->content->{select_many} = $self->select_many;
    $self->result->content->{select_one}  = $self->select_one;
    $self->result->content->{text}        = $self->text;
    $self->result->content->{value}       = $self->value;
}

1;
