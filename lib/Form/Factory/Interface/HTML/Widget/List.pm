package Form::Factory::Interface::HTML::Widget::List;

use Moose;

extends qw( Form::Factory::Interface::HTML::Widget::Element );

=head1 NAME

Form::Factory::Interface::HTML::Widget::List - HTML interface widget helper

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

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=begin Pod::Coverage

  .*

=end Pod::Coverage

=cut

1;
