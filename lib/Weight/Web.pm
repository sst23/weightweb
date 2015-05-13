package Weight::Web;
use strict;
use warnings;
use 5.14.0;
use OX;
use OX::RouteBuilder::REST;

use Path::Class;

has template_path => (
    is => 'ro',
    isa => 'Str',
    default  => sub {
        file(__FILE__)->absolute->parent->parent->parent->subdir('templates')->stringify
    }
);

has static_path => (
    is => 'ro',
    isa => 'Str',
    default  => sub {
        file(__FILE__)->absolute->parent->parent->parent->subdir('data')->stringify
    }
);

has haml => (
    is => 'ro',
    isa => 'Weight::Web::View',
    dependencies => ['template_path'],
);

has calendar => (
    is => 'ro',
    isa => 'Weight::Web::Model',
    # if you don't edit the data outside ~/.weight.txt enable the singleton
    # lifecycle => 'Singleton'
);

has root => (
    is => 'ro',
    isa => 'Weight::Web::Controller',
    infer => 1,
);

router as {
    wrap 'Plack::Middleware::Static' => (
        root => 'static_path',
        path => literal(qr{^/static/})
    );

    route '/'             => 'root.index';
    route '/weight'       => 'REST.root.weight';
    route '/weight/:date' => 'REST.root.weight' => (date => { isa => 'Str' });
};

no OX;
1;
