package Form::Factory::Interface::HTML::Widget::Label;

use Moose;

extends qw( Form::Factory::Interface::HTML::Widget::Element );

# ABSTRACT: HTML interface widget helper

=head1 DESCRIPTION

Move along. Nothing to see here.

=cut

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

=begin Pod::Coverage

  .*

=end Pod::Coverage

=cut

__PACKAGE__->meta->make_immutable;
