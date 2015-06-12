package Form::Factory::Interface::HTML::Widget::List;

use Moose;

extends qw( Form::Factory::Interface::HTML::Widget::Element );

# ABSTRACT: HTML interface widget helper

=head1 DESCRIPTION

Move along. Nothing to see here.

=cut

has '+tag_name' => (
    default   => 'ul',
);

has items => (
    is        => 'ro',
    isa       => 'ArrayRef[Form::Factory::Interface::HTML::Widget::ListItem]',
    required  => 1,
    default   => sub { [] },
);

sub has_content { 1 }

sub render_items {
    my $self = shift;
    my $content = '';
    for my $item (@{ $self->items }) {
        $content .= $item->render;
    }
    return $content;
}

override render_content => sub {
    my $self = shift;
    return super() . $self->render_items;
};

sub consume_control { }

=begin Pod::Coverage

  .*

=end Pod::Coverage

=cut

__PACKAGE__->meta->make_immutable;
