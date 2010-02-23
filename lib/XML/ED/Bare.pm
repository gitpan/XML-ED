package XML::ED::Bare;

use Carp;
use strict;
use vars qw( @ISA @EXPORT @EXPORT_OK $VERSION );
use utf8;
require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);

$VERSION = "0.0.1";

use vars qw($VERSION *AUTOLOAD);

*AUTOLOAD = \&XML::ED::Bare::AUTOLOAD;
bootstrap XML::ED::Bare $VERSION;

@EXPORT = qw( );
@EXPORT_OK = qw( xget merge clean add_node del_node find_node del_node forcearray del_by_perl xmlin xval );

=head1 NAME

XML::ED::Bare - Minimal XML parser implemented via a C state engine

=head1 VERSION

0.45

=cut

sub new {
  my $class = shift; 
  my $self  = { @_ };
  
  if( $self->{ 'text' } ) {
    XML::ED::Bare::c_parse( $self->{'text'} );
  }
  else {
    my $res = open( XML, $self->{ 'file' } );
    if( !$res ) {
      $self->{ 'xml' } = 0;
      return 0;
    }
    {
      local $/ = undef;
      $self->{'text'} = <XML>;
    }
    close( XML );
    XML::ED::Bare::c_parse( $self->{'text'} );
  }
  bless $self, $class;
  return $self if( !wantarray );
  return ( $self, $self->parse() );
}

sub DESTROY {
  my $self = shift;
  undef $self->{'xml'};
}


# Load a file using XML::ED::DOM, convert it to a hash, and return the hash
sub parse {
  my $self = shift;
  
  my $res = XML::ED::Bare::xml2obj();
  $self->{'structroot'} = XML::ED::Bare::get_root();
  $self->free_tree();
  
  if( defined( $self->{'scheme'} ) ) {
    $self->{'xbs'} = new XML::ED::Bare( %{ $self->{'scheme'} } );
  }
  if( defined( $self->{'xbs'} ) ) {
    my $xbs = $self->{'xbs'};
    my $ob = $xbs->parse();
    $self->{'xbso'} = $ob;
    readxbs( $ob );
  }
  
  if( $res < 0 ) { croak "Error at ".$self->lineinfo( -$res ); }
  $self->{ 'xml' } = $res;
  
  if( defined( $self->{'xbso'} ) ) {
    my $ob = $self->{'xbso'};
    my $cres = $self->check( $res, $ob );
    croak( $cres ) if( $cres );
  }
  
  return $self->{ 'xml' };
}

sub free_tree { my $self = shift; XML::ED::Bare::free_tree_c( $self->{'structroot'} ); }

1;

__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Module Functions

=over 2

=item * C<< $ob = XML::ED::Bare->new( text => "[some xml]" ) >>

Create a new XML object, with the given text as the xml source.

=item * C<< parse >>

=item * C<< c_parse >>

=item * C<< free_tree >>

=item * C<< free_tree_c >>

=item * C<< get_root >>

=item * C<< xml2obj >>

=back

=head1 AUTHOR


G. Allen Morris III <gam3@gam3.net>

=head1 LICENSE

  Copyright (C) 2010 G. Allen Morris III

  Portions may be Copyright (C) 2008 David Helkowski
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation; either version 2 of the
  License, or (at your option) any later version.  You may also can
  redistribute it and/or modify it under the terms of the Perl
  Artistic License.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

=head1 SEE ALSO

L<XML::ED>, perl(1), L<XML::Bare>, L<XML::XPath>

L<http://www.gam3.org>

L<http://www.w3.org/TR/xpath20/>

=cut

