package Template::Plugin::Pygments;

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
# [% FILTER $pygments lang = 'bash', path = '/opt/local/bin/pygments' %]
# #!/bin/bash
# set -x
# [% END %]
sub filter {
    my ($self, $text, $args, $conf) = @_;
    $conf = $self->merge_config($conf);

    my @lexer = $conf->{'lang'} ? ('-l', $conf->{'lang'}) : ();
    my $pyg_path = $conf->{'path'} || 'pygmentize';

    # Make 2 file handles
    my ($in_fh, $in_fn) = tempfile('pygXXXXX');
    my ($out_fh, $out_fn) = tempfile('pygXXXXX');

    # Put text in $in
    print $in_fh $text;
    close $out_fh;

    # Run command line tool
    my @cmd = ($pyg_path, @lexer, qw(-f html -o), $out_fn, $in_fn);
    system(@cmd);

    # Read reformatted text
    my $fmt_text = do {
        if (open my $fh, $out_fn) {
            local $/;
            <$fh>;
        }
    };

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
