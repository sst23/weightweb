package Weight::Web::Model;
use strict;
use warnings;
use 5.14.0;
use Moose;
use File::HomeDir;
use Path::Class;
use Time::Piece;

has _file => (
    is => 'ro',
    isa => 'Path::Class::File',
    required => 1,
    default => sub { dir(File::HomeDir->my_home)->file('.weight.txt'); }
);

has weight_table => (
    is => 'ro',
    isa => 'HashRef[Str]',
    required => 1,
    builder => '_build_weight_table',
    traits => ['Hash'],
    handles => {
        get_weight => 'get',
        set_weight => 'set',
        count => 'count',
        pairs => 'kv',
        dates => 'keys'
    }
);

after 'set_weight' => sub {
    my $self = shift;

    my $out = [];
    foreach my $date (sort $self->dates) {
        my $str = localtime($date)->strftime('%Y-%m-%d');
        my $weight = $self->get_weight($date);
        push @$out, "$str $weight";
    }
    $self->_file->spew_lines($out);
};

sub to_epoch {
    my $self = shift;
    my $date = shift;
    my $time = Time::Piece->strptime($date, '%Y-%m-%d');
    $time += 60*60*2;
    return $time->epoch;
}

sub _build_weight_table {
    my $self = shift;
    my $ret = {};
    return $ret unless -e $self->_file;

    foreach my $line ($self->_file->slurp(chomp => 1)) {
        my ($date, $weight) = split(' ', $line, 2);
        $ret->{ $self->to_epoch($date) } = $weight;
    }
    return $ret;
}

sub TO_JSON {
    my $self = shift;
    my $ret = [];

    foreach my $date (sort $self->dates) {
        push @$ret, { x => int($date), y => ($self->get_weight($date) + 0.0) };
    }

    return $ret;
}

__PACKAGE__->meta->make_immutable;

1;
