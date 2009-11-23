package FormFactory::Feature;
use Moose::Role;

use Scalar::Util qw( blessed );

requires qw( clean check pre_process post_process );

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 1,
    default   => sub {
        my $self = shift;
        my $class_name = blessed $self;
        unless ($class_name =~ s/^FormFactory::Feature::Control:://) {
            $class_name =~ s/^FormFactory::Feature:://;
        }
        $class_name =~ s/(\p{Lu})/_\l$1/g;
        $class_name =~ s/\W+/_/g;
        $class_name =~ s/_+/_/g;
        $class_name =~ s/^_//;
        return lc $class_name;
    },
);

has action => (
    is        => 'ro',
    isa       => 'FormFactory::Action',
    required  => 1,
    weak_ref  => 1,
);

has message => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_message',
);

has result => (
    is        => 'ro',
    isa       => 'FormFactory::Result::Single',
    required  => 1,
    default   => sub { FormFactory::Result::Single->new },
);

sub feature_info {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->info($message);
}

sub feature_warning {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->warning($message);
}

sub feature_error {
    my $self    = shift;
    my $message = $self->message || shift;
    $self->result->error($message);
}

1;
