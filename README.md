Template::Plugin::Pygments
==========================

A [Template Toolkit](http://tt2.org/) plugin that formats text using
[pygments](http://pygments.org).

Usage
=====

    [% USE Pygments]

    [% FILTER $Pygments lang = 'php' %]
    <pre>
    <?php phpinfo(); ?>
    </pre>
    [% END %]
