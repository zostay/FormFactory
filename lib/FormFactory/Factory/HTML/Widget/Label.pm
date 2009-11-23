package FormFactory::Factory::HTML::Widget::Label;
use Moose;

extends qw( FormFactory::Factory::HTML::Widget::Element );

has '+tag_name' => (
    default   => 'label',
);

has for => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has '+content' => (
    required  => 1,
);

override more_attributes => sub {
    my $self = shift;

    return {
        for => $self->for,
    };
};

1;
