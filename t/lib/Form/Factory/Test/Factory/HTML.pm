package Form::Factory::Test::Factory::HTML;
use Test::Able;
use Test::More;

with qw( Form::Factory::Test::Factory );

has '+name' => (
    default => 'HTML',
);

1;
