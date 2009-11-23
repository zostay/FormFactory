package FormFactory::Factory::HTML::Widget::Textarea;
use Moose;

extends qw( FormFactory::Factory::HTML::Widget::Element );

has '+tag_name' => (
    default   => 'textarea',
);

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has rows => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_rows',
);

has cols => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_cols',
);

sub has_content { 1 }

override more_attributes => sub {
    my $self = shift;

    my %attributes = (
        name => $self->name,
    );

    $attributes{rows} = $self->rows if $self->has_rows;
    $attributes{cols} = $self->cols if $self->has_cols;

    return \%attributes;
};

sub consume_control {
    my ($self, %options) = @_;
    my $params = $options{params};
    my $name   = $self->name;

    return { $name => $params->{ $name } };
}

1;
