Template::Plugin::Pygments
==========================

A [Template Toolkit](http://tt2.org/) plugin that formats text using
[pygments](http://pygments.org).

Usage
=====

From a template:

    [% USE Pygments %]

    [% FILTER $Pygments lang = 'php' %]
    <pre>
    <?php phpinfo(); ?>
    </pre>
    [% END %]

Output:

<div class="highlight"><pre><span class="x">    &lt;pre&gt;</span>
<span class="x">    </span><span class="cp">&lt;?php</span> <span class="nb">phpinfo</span><span class="p">();</span> <span class="cp">?&gt;</span><span class="x"></span>
<span class="x">    &lt;/pre&gt;</span>
<span class="x">    </span>
</pre></div> 
