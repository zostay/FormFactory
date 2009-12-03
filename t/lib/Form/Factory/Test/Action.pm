package Form::Factory::Test::Action;
use Test::Able::Role;

has output => (
    is        => 'rw',
    isa       => 'Str',
    required  => 1,
    default   => '',
);

has interface => (
    is        => 'ro',
    does      => 'Form::Factory::Interface',
    required  => 1,
    lazy      => 1,
    default   => sub { 
        my $self = shift;
        Form::Factory->new_interface(HTML => {
            renderer => sub { 
                $self->output( join('', $self->output, @_) )
            },
        }); 
    },
);

has action => (
    is        => 'ro',
    does      => 'Form::Factory::Action',
    required  => 1,
);

teardown clear_output => sub {
    my $self = shift;
    $self->output('');
};

1;
