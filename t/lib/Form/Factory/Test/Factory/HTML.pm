package FormFactory::Test::Factory::HTML;
use Test::Able;
use Test::More;

with qw( FormFactory::Test::Factory );

has '+name' => (
    default => 'HTML',
);

1;
