package HTML::StripScripts::Parser;
use strict;

use vars qw($VERSION);
$VERSION = '0.04';
# $Rev: 97 $

=head1 NAME

HTML::StripScripts::Parser - XSS filter using HTML::Parser

=head1 SYNOPSIS

  use HTML::StripScripts::Parser;

  my $hss = HTML::StripScripts::Parser->new(
       { Context => 'Document' },
       strict_comment => 1,
       strict_names   => 1,
  );

  $hss->parse_file("foo.html");

  print $hss->filtered_document;

=head1 DESCRIPTION

This class subclasses both L<HTML::StripScripts> and L<HTML::Parser>,
adding the input methods that L<HTML::Parser> provides to
L<HTML::StripScripts>.

See L<HTML::StripScripts> and L<HTML::Parser>.

=cut

=head1 CONSTRUCTORS

=over

=item new ( CONFIG, [PARSER_OPTIONS]  )

Creates a new C<HTML::StripScripts::Parser> object, and invokes the
L<HTML::Parser> init() method so that tags are fed to the correct
L<HTML::StripScripts> methods.

The CONFIG parameter has the same semantics as the CONFIG
parameter to the L<HTML::StripScripts> constructor.

Any PARSER_OPTIONS supplied will be passed on to the L<HTML::Parser>
init method, allowing you to influence the way the input is parsed.

You cannot use PARSER_OPTIONS to set L<HTML::Parser> event handlers,
since C<HTML::StripScripts::Parser> uses all of the event hooks
itself.

=cut

use HTML::StripScripts;
use HTML::Parser;
use base qw(HTML::StripScripts HTML::Parser);

sub hss_init {
    my ($self, $cfg, @parser_options) = @_;

    $self->init(
       @parser_options,

       api_version      => 3,
       start_document_h => ['input_start_document', 'self'],
       start_h          => ['input_start',          'self,text'],
       end_h            => ['input_end',            'self,text'],
       text_h           => ['input_text',           'self,text'],
       default_h        => ['input_text',           'self,text'],
       declaration_h    => ['input_declaration',    'self,text'],
       comment_h        => ['input_comment',        'self,text'],
       process_h        => ['input_process',        'self,text'],
       end_document_h   => ['input_end_document',   'self'],

       # workaround for http://rt.cpan.org/NoAuth/Bug.html?id=3954
       ( $HTML::Parser::VERSION =~ /^3\.(29|30|31)$/
           ?  ( strict_comment => 1 )
           :  ()
       ),
    );

    $self->SUPER::hss_init($cfg);
}

=back

=head1 METHODS

See L<HTML::Parser> for input methods, L<HTML::StripScripts> for output
methods.

=head1 SUBCLASSING

The C<HTML::StripScripts::Parser> class is subclassable.  Filter objects
are plain hashes.  The hss_init() method takes the same arguments as
new(), and calls the initialization methods of both C<HTML::StripScripts>
and C<HTML::Parser>.

See L<HTML::StripScripts/"SUBCLASSING"> and L<HTML::Parser/"SUBCLASSING">.

=head1 SEE ALSO

L<HTML::StripScripts>, L<HTML::Parser>

=head1 AUTHOR

Nick Cleaton E<lt>nick@cleaton.netE<gt>

=head1 COPYRIGHT

Copyright (C) 2003 Nick Cleaton.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
