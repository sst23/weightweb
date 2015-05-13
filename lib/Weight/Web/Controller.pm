package Weight::Web::Controller;
use strict;
use warnings;
use 5.14.0;
use Moose;
use JSON::XS;
use Time::Piece;
use Plack::Request;
use HTTP::Throwable::Factory qw/http_throw/;

has model => (
    is => 'ro',
    isa => 'Weight::Web::Model',
    required => 1
);

has view => (
    is => 'ro',
    isa => 'Weight::Web::View',
    required => 1
);

has json => (
    is => 'ro',
    required => 1,
    default => sub { JSON::XS->new->utf8->convert_blessed }
);

sub index {
    my ($self, $r) = @_;
    $self->view->render($r, 'index', {today => localtime->ymd});
}

sub weight_GET {
    my $self = shift;
    return [200, [ 'Content-type' => 'application/json' ], $self->json->encode($self->model) ];
}

sub weight_POST {
    my ($self, $r, $date) = @_;

    my $pr = Plack::Request->new($r->env);
    my $weight = $pr->body_parameters->get('weight');

    http_throw(BadRequest => {message => 'Invalid date format'}) if $date !~ m#^([0-9-]+)$#;
    http_throw(BadRequest => {message => 'Invalid weight format'}) if $weight !~ m#^([0-9.]+)$#;

    $self->model->set_weight($self->model->to_epoch($date), $weight);

    return [200, [ 'Content-type' => 'application/json' ], $self->json->encode($self->model) ];
}

__PACKAGE__->meta->make_immutable;

1;
