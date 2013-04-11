package Template::Plugin::Pygments;

# -------------------------------------------------------------------
# Template::Plugin::Pygments - Colorize a block of text using Pygments
# Copyright (C) 2013 darren chamberlain <darren@cpan.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307  USA
# -------------------------------------------------------------------

use strict;
use vars qw($VERSION);

use File::Temp qw(tempfile);
use Template::Plugin::Filter;
use base qw(Template::Plugin::Filter);

$VERSION = "1.00";

sub init {
    my $self = shift;
    $self->{ _DYNAMIC } = 1;
    return $self;
}

# [% USE pygments %]
#
# [% FILTER $pygments
#        lang        = 'bash',
#        foramtter   = 'html',
#        path        = '/opt/local/bin/pygmentize'
# %]
# #!/bin/bash
# set -x
# [% END %]
sub filter {
    my ($self, $text, $args, $conf) = @_;
    $conf = $self->merge_config($conf);

    my @lexer       = $conf->{'lang'} ? ('-l', $conf->{'lang'}) : ('-g');
    my $frmtr       = $conf->{'formatter'} || 'html';
    my $pyg_path    = $conf->{'path'} || 'pygmentize';

    # Make 2 file handles
    my ($in_fh, $in_fn)     = tempfile('pygXXXXX');
    my ($out_fh, $out_fn)   = tempfile('pygXXXXX');

    # Put text in $in
    print $in_fh $text;
    close $out_fh;

    # Run command line tool
    my @cmd = ($pyg_path, @lexer, '-f', $frmtr, '-o', $out_fn, $in_fn);
    my $fmt_text;

    if (0 == system(@cmd)) {
        # Read reformatted text, if the command ran correctly
        $fmt_text = do {
            if (open my $fh, $out_fn) {
                local $/;
                <$fh>;
            }
        };
    }

    # Delete temp files
    unlink $in_fn;
    unlink $out_fn;

    return $fmt_text || $text;
}

1;

=head1 NAME

Template::Plugin::Pygments - Colorize a block of text using Pygments

=head1 SYNOPSIS

    [% USE pygments %]

    [% FILTER pygments lang="perl" %]
    print "Hello from $^T!";
    [% END %]

=head1 DESCRIPTION

C<Template::Plugin::Pygments> is a Template Toolkit wrapper for Pygments.

=head1 AUTHOR

Darren Chamberlain E<lt>darren@cpan.orgE<gt>
