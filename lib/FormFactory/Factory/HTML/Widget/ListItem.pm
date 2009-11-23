package FormFactory::Factory::HTML::Widget::ListItem;
use Moose;

extends qw( FormFactory::Factory::HTML::Widget::Element );

has '+tag_name' => (
    default   => 'li',
);

has '+content' => (
    required  => 1,
);

sub has_content { 1 }

1;
