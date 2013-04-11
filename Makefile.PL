use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Template::Plugin::Pygments',
    'VERSION_FROM'  => 'lib/Template/Plugin/Pygments.pm',
    'PREREQ_PM'     => {
        'Template'  => '2.07',
    },
    'clean'         => {
        'FILES' => '$(DISTVNAME).tar$(SUFFIX) *.ppd'
    },
    'AUTHOR'        => 'Darren Chamberlain <darren@cpan.org>',
    'ABSTRACT_FROM' => 'lib/Template/Plugin/Pygments.pm',
);

