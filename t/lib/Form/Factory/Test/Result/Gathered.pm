package Form::Factory::Test::Result::Gathered;
use Test::Able;
use Test::More;

with qw( Form::Factory::Test::Result );

use Form::Factory::Result::Gathered;
use Form::Factory::Result::Single;

use constant Gathered => 'Form::Factory::Result::Gathered';
use constant Single   => 'Form::Factory::Result::Single';

has '+result_class' => (
    default   => 'Form::Factory::Result::Gathered',
);

test plan => 2, cant_gather_self => sub {
    my $self = shift;

    my $results = Gathered->new;
    eval { $results->gather_results($results) };

    ok($@, 'got error');
    like($@, qr/\brecursively\b/, 'recursively');
};

test plan => 2, gathering_all_valid_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_->is_valid(1); $_ } 1 .. 4;

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok($results->is_valid, 'truly valid');
};

test plan => 2, gathering_some_valid_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_ } 1 .. 4;
    $results[2]->is_valid(1);

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok($results->is_valid, 'truly valid');
};

test plan => 2, gather_all_invalid_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_->is_valid(0); $_ } 1 .. 4;

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok(!$results->is_valid, 'truly invalid');
};

test plan => 2, gathering_some_invalid_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_ } 1 .. 4;
    $results[2]->is_valid(0);

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok(!$results->is_valid, 'truly invalid');
};

test plan => 2, gather_all_mixed_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_->is_valid(1); $_ } 1 .. 4;
    $results[2]->is_valid(0);

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok(!$results->is_valid, 'truly invalid');
};

test plan => 2, gathering_some_invalid_singles_ok => sub {
    my $self = shift;

    my @results = map { $_ = Single->new; $_ } 1 .. 4;
    $results[0]->is_valid(1);
    $results[2]->is_valid(0);

    my $results = Gathered->new;
    $results->gather_results(@results);

    ok($results->is_validated, 'truly validated');
    ok(!$results->is_valid, 'truly invalid');
};

1;
