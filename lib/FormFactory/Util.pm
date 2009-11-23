package FormFactory::Util;
use Moose;

use Sub::Exporter -setup => {
    exports => [ qw(
        class_name_from_name
    ) ],
};

sub class_name_from_name($) {
    my ($name) = @_;

    $name =~ s/(?:[^A-Za-z]+|^)([A-Za-z])/\U$1/g;
    return ucfirst $name;
}

1;
