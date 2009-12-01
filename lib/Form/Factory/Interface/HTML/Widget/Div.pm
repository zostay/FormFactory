package Form::Factory::Interface::HTML::Widget::Div;
use Moose;

extends qw( Form::Factory::Interface::HTML::Widget::Element );

=head1 NAME

Form::Factory::Interface::HTML::Widget::Div - HTML interface widget helper

=head1 DESCRIPTION

Move along. Nothing to see here.

=cut

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
