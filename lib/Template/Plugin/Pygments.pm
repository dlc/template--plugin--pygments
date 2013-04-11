package Template::Plugin::Pygments;

use strict;

use File::Temp qw(tempfile);
use Template::Plugin::Filter;
use base qw(Template::Plugin::Filter);

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
    my $conf = $self->merge_config($conf);

    my @lexer = $conf->{'lang'} ? ('-l', $conf->{'lexer'}) : ();
    my $pyg_path = $conf->{'path'} || 'pygments';

    # Make 2 file handles
    my ($in_fh, $in_fn) = tempfile('pygXXXXX');
    my ($out_fh, $out_fn) = tempfile('pygXXXXX');

    # Put text in $in
    print $in_fh $text;
    close $out_fh;

    # Run command line tool
    system($pyg_path, @lexer, qw(-f html -o), $out_fn, $in_fn);

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
