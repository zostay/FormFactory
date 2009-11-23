package Moose::Meta::Attribute::Custom::Trait::Form::Control;
sub register_implementation { 'FormFactory::Action::Meta::Attribute::Control' }

package FormFactory::Action::Meta::Attribute::Control;
use Moose::Role;

has placement => (
    is        => 'ro',
    isa       => 'Num',
    required  => 1,
    default   => 0,
);

has control => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    default   => 'text',
);

has options => (
    is        => 'ro',
    isa       => 'HashRef',
    required  => 1,
    default   => sub { {} },
);

has features => (
    is          => 'ro',
    isa         => 'HashRef[HashRef]',
    required    => 1,
    default     => sub { {} },
);

1;
