use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'HTML::StripScripts::Parser',
    'VERSION_FROM' => 'Parser.pm',
    'PREREQ_PM'    => {
                        'Test::More'         => 0,
                        'HTML::StripScripts' => 0,
                        'HTML::Parser'       => 3.25,
                      },
);

