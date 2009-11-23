package FormFactory::Factory::HTML;
use Moose;

with qw( FormFactory::Factory );

use Scalar::Util qw( blessed );

use FormFactory::Factory::HTML::Widget::Div;
use FormFactory::Factory::HTML::Widget::Input;
use FormFactory::Factory::HTML::Widget::Label;
use FormFactory::Factory::HTML::Widget::List;
use FormFactory::Factory::HTML::Widget::ListItem;
use FormFactory::Factory::HTML::Widget::Select;
use FormFactory::Factory::HTML::Widget::Span;
use FormFactory::Factory::HTML::Widget::Textarea;

has renderer => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
    default   => sub { sub { print @_ } },
);

has consumer => (
    is        => 'ro',
    isa       => 'CodeRef',
    required  => 1,
    default   => sub { sub { my %params = @_; $params{request} } },
);

sub new_widget_for_control {
    my $self    = shift;
    my $control = shift;
    my $results = shift;

    my $control_type = blessed $control;
    my ($name) = $control_type =~ /^FormFactory::Control::(\w+)$/;
    return unless $name;
    $name = lc $name;

    my @alerts;
    @alerts = _alerts_for_control($control->name, $name, $results)
        if $results;

    my $method = 'new_widget_for_' . $name;
    return $self->$method($control, @alerts) if $self->can($method);
    return;
}

sub _wrapper($$@) {
    my ($name, $type, @widgets) = @_;

    return FormFactory::Factory::HTML::Widget::Div->new(
        id      => $name . '-wrapper',
        classes => [ qw( widget wrapper ), $type ],
        widgets => \@widgets,
    );
}

sub _label($$$;$) {
    my ($name, $type, $label, $is_required) = @_;

    return FormFactory::Factory::HTML::Widget::Label->new(
        id      => $name . '-label',
        classes => [ qw( widget label ), $type ],
        for     => $name,
        content => $label . _required_marker($is_required),
    );
}

sub _required_marker($) {
    my ($is_required) = @_;
    
    if ($is_required) {
        return FormFactory::Factory::HTML::Widget::Span->new(
            classes => [ qw( required ) ],
            content => '*',
        )->render;
    }
    else {
        return '';
    }
}

sub _input($$$;$%) {
    my ($name, $type, $input_type, $value, %args) = @_;

    return FormFactory::Factory::HTML::Widget::Input->new(
        id      => $name,
        name    => $name,
        type    => $input_type,
        classes => [ qw( widget field ), $type ],
        value   => $value || '',
        %args,
    );
}

sub _alerts($$@) {
    my ($name, $type, @items) = @_;

    return FormFactory::Factory::HTML::Widget::List->new(
        id      => $name . '-alerts',
        classes => [ qw( widget alerts ), $type ],
        items   => \@items,
    );
}

sub _alerts_for_control {
    my ($name, $type, $results) = @_;
    my @items;

    my $count = 0;
    my @messages = $results->field_messages($name);
    for my $message (@messages) {
        push @items, FormFactory::Factory::HTML::Widget::ListItem->new(
            id      => $name . '-message-' . ++$count,
            classes => [ qw( widget message ), $type, $message->type ],
            content => $message->english_message,
        );
    }

    return @items;
}

sub new_widget_for_button {
    my ($self, $control) = @_;

    return _input($control->name, 'button', 'submit', $control->label);
}

sub new_widget_for_checkbox {
    my ($self, $control, @alerts) = @_;

    return _wrapper($control->name, 'checkbox', 
        _input($control->name, 'checkbox', 'checkbox', $control->current_value, 
            checked => $control->is_checked),
        _label($control->name, 'checkbox', $control->label),
        _alerts($control->name, 'checkbox', @alerts),
    );
}

sub new_widget_for_fulltext {
    my ($self, $control, @alerts) = @_;

    return _wrapper($control->name, 'full-text',
        _label($control->name, 'full-text', $control->label, 
            $control->has_feature('required')),
        FormFactory::Factory::HTML::Widget::Textarea->new(
            id      => $control->name,
            name    => $control->name,
            classes => [ qw( widget field full-text ) ],
            content => $control->current_value,
        ),
        _alerts($control->name, 'full-text', @alerts),
    );
}

sub new_widget_for_password {
    my ($self, $control, @alerts) = @_;

    return _wrapper($control->name, 'password',
        _label($control->name, 'password', $control->label,
            $control->has_feature('required')),
        _input($control->name, 'password', 'password', $control->current_value),
        _alerts($control->name, 'password', @alerts),
    );
}

sub new_widget_for_selectmany {
    my ($self, $control, @alerts) = @_;

    my @checkboxes;
    for my $choice (@{ $control->available_choices }) {
        push @checkboxes, _input(
            $choice->name, 'select-many choice', 'checkbox', 
            $choice->value, checked => $control->is_choice_selected($choice),
        );
    }

    return _wrapper($control->name, 'select-many',
        _label($control->name, 'select-many', $control->label,
            $control->has_feature('required')),
        FormFactory::Factory::HTML::Widget::Div->new(
            id      => $control->name . '-list',
            classes => [ qw( widget list select-many ) ],
            widgets => \@checkboxes,
        ),
        _alerts($control->name, 'select-many', @alerts),
    );
}

sub new_widget_for_selectone {
    my ($self, $control, @alerts) = @_;

    return _wrapper($control->name, 'select-one',
        _label($control->name, 'select-one', $control->label,
            $control->has_feature('required')),
        FormFactory::Factory::HTML::Widget::Select->new(
            id       => $control->name,
            name     => $control->name,
            classes  => [ qw( widget field select-one ) ],
            size     => 1,
            available_choices => $control->available_choices,
            selected_choices  => [ $control->current_value ],
        ),
        _alerts($control->name, 'select-one', @alerts),
    );
}

sub new_widget_for_text {
    my ($self, $control, @alerts) = @_;

    return _wrapper($control->name, 'text',
        _label($control->name, 'text', $control->label,
            $control->has_feature('required')),
        _input($control->name, 'text', 'text', $control->current_value),
        _alerts($control->name, 'text', @alerts),
    );
}

sub new_widget_for_value {
    my ($self, $control, @alerts) = @_;

    if ($control->is_visible) {
        return _wrapper($control->name, 'value',
            _label($control->name, 'value', $control->label),
            FormFactory::Factory::HTML::Widget::Span->new(
                id      => $control->name,
                content => $control->value,
                classes => [ qw( widget field value ) ],
            ),
            _alerts($control->name, 'text', @alerts),
        );
    }

    return;
}

sub render_control {
    my ($self, $control, %options) = @_;

    my $widget = $self->new_widget_for_control($control, $options{results});
    return unless $widget;
    $self->renderer->($widget->render);
}

sub consume_control {
    my ($self, $control, %options) = @_;

    die "no request option passed" unless defined $options{request};

    die "HTML factory does not know how to consume values for $control"
        unless $control->does('FormFactory::Control::Role::ScalarValue')
            or $control->does('FormFactory::Control::Role::ListValue');

    my $widget = $self->new_widget_for_control($control);
    return unless defined $widget;

    my $params = $widget->consume( params => $self->consumer->($options{request}) );

    return unless defined $params->{ $control->name };

    if ($control->does('FormFactory::Control::Role::ScalarValue')) {
        $control->current_value( $params->{ $control->name } );
    }
    else {
        $control->current_values( $params->{ $control->name } );
    }
}

1;
