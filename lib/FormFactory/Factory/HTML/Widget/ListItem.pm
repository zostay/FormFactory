package FormFactory::Factory::HTML::Widget::ListItem;
use Moose;

extends qw( FormFactory::Factory::HTML::Widget::Element );

=head1 NAME

FormFactory::Factory::HTML::Widget::ListItem - HTML factory widget helper

=head1 DESCRIPTION

Move along. Nothing to see here.

=cut

has '+tag_name' => (
    default   => 'li',
);

has '+content' => (
    required  => 1,
);

sub has_content { 1 }

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
