package Weight::Web::View;
use strict;
use warnings;
use 5.14.0;

use Moose;
use Path::Class;
use Text::Haml;
use Data::Dumper;

has template_path => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has haml => (
    is => 'ro',
    isa => 'Text::Haml',
    required => 1,
    default => sub { Text::Haml->new }
);

sub render {
    my ($self, $request, $template, $params) = @_;

    my $file = dir($self->template_path)->file($template.'.haml')->stringify;
    my $text = $self->haml->render_file($file, %$params);

    print Dumper($self->haml->error) if $self->haml->error;
    return $text;
}

__PACKAGE__->meta->make_immutable;

1;
