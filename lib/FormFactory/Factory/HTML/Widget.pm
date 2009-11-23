package FormFactory::Factory::HTML::Widget;
use Moose::Role;

requires qw( render_control consume_control );

=head1 NAME

FormFactory::Factory::HTML::Widget - rendering/processing HTML controls

=head1 DESCRIPTION

Widget is the low-level API for rendering and processing HTML/HTTP form elements.

=head1 ATTRIBUTES

=head2 alternate_renderer

If the renderer needs to be customized, provide a custom renderer here. This is a code reference that is passed the control and options like the usual renderer method.

=cut

has alternate_renderer => (
    is        => 'rw',
    isa       => 'CodeRef',
    predicate => 'has_alternate_renderer',
);

=head2 alternate_consumer

If the control needes to be consumed in a custom way, you can add that here. This is a code reference that is passed the control and options like the usual consumer method.

=cut

has alternate_consumer => (
    is        => 'rw',
    isa       => 'CodeRef',
    predicate => 'has_alternate_consumer',
);

=head1 METHODS

=head2 render

Renders the HTML required to use this method.

=cut

sub render {
    my $self     = shift;

    if ($self->has_alternate_renderer) {
        return $self->alternate_renderer->($self, @_);
    }
    else {
        return $self->render_control(@_);
    }
}

=head2 consume

Consumes the value from the request.

=cut

sub consume {
    my $self = shift;

    if ($self->has_alternate_consumer) {
        $self->alternate_consumer->($self, @_);
    }
    else {
        $self->consume_control(@_);
    }
}

=head1 ROLE METHODS

These methods must be implemented by role implementers.

=head2 render_control

Return HTML to render the control.

=head2 consume_control

Given consumer options, process the input.

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=cut

1;
