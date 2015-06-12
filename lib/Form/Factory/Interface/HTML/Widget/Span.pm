package Form::Factory::Interface::HTML::Widget::Span;

use Moose;

extends qw( Form::Factory::Interface::HTML::Widget::Element );

# ABSTRACT: HTML interface widget helper

=head1 DESCRIPTION

Move along. Nothing to see here.

=cut

has '+tag_name' => (
    default   => 'span',
);

has '+content' => (
    required  => 1,
);

sub has_content { 1 }

=begin Pod::Coverage

  .*

=end Pod::Coverage

=cut

__PACKAGE__->meta->make_immutable;
