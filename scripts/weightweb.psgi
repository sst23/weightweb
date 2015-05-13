#!/usr/bin/env perl
use 5.14.0;
use strict;
use warnings;
use lib qw#../lib#;
use Weight::Web;

Weight::Web->new->to_app;
