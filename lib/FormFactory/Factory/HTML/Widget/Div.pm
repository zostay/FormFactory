package FormFactory::Factory::HTML::Widget::Div;
use Moose;

extends qw( FormFactory::Factory::HTML::Widget::Element );

has '+tag_name' => (
    default   => 'div',
);

has widgets => (
    is        => 'ro',
    isa       => 'ArrayRef',
    required  => 1,
    default   => sub { [] },
);

sub has_content { 1 }

sub render_widgets {
    my $self = shift;
    my $content = '';
    for my $widget (@{ $self->widgets }) {
        $content .= $widget->render;
    }
    return $content;
}

override render => sub {
    my $self = shift;
    return super() . $self->render_widgets;
};

sub consume_control {
    my $self = shift;
    my %args_accumulator;

    %args_accumulator = (%args_accumulator, %{ $_->consume(@_) || {} }) 
        for @{ $self->widgets };

    return \%args_accumulator;
}

1;
