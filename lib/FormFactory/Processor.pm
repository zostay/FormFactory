package FormFactory::Processor;
use Moose;
use Moose::Exporter;

use FormFactory::Action;
use FormFactory::Action::Meta::Class;
use FormFactory::Action::Meta::Attribute::Control;
use FormFactory::Processor::DeferredValue;

Moose::Exporter->setup_import_methods(
    as_is     => [ qw( deferred_value ) ],
    with_meta => [ qw(
        has_control
        has_cleaner has_checker has_pre_processor has_post_processor
    ) ],
    also      => 'Moose',
);

sub init_meta {
    my $package = shift;
    my %options = @_;

    Moose->init_meta(%options);

    my $meta = Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $options{for_class},
        metaclass_roles => [ 'FormFactory::Action::Meta::Class' ],
    );

    Moose::Util::apply_all_roles(
        $options{for_class}, 'FormFactory::Action',
    );

    return $meta;
}

sub has_control {
    my $meta = shift;
    my $name = shift;
    my $args = @_ == 1 ? shift : { @_ };

    $args->{is}       ||= 'ro';
    $args->{isa}      ||= 'Str';

    $args->{control}  ||= 'text';
    $args->{options}  ||= {};
    $args->{features} ||= {};
    $args->{traits}   ||= [];

    for my $value (values %{ $args->{features} }) {
        $value = {} unless ref $value;
    }

    unshift @{ $args->{traits} }, 'Form::Control';

    $meta->add_attribute( $name => $args );
}

sub deferred_value(&) {
    my $code = shift;

    return FormFactory::Processor::DeferredValue->new(
        code => $code,
    );
}

sub _add_feature {
    my ($type, $meta, $name, $code) = @_;
    die "bad code given for $type $name" unless defined $code;
    $meta->features->{functional}{$type . '_code'}{$name} = $code;
}

sub has_cleaner        { _add_feature('cleaner', @_) }
sub has_checker        { _add_feature('checker', @_) }
sub has_pre_processor  { _add_feature('pre_processor', @_) }
sub has_post_processor { _add_feature('post_processor', @_) }

1;
