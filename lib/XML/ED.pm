
package XML::ED;

our $VERSION = 'v0.0.1';

=head1 NAME

XML::ED - A process to impliemtent editing of xml files.

=head1 VERSION

v0.0.1

=head1 METHODS

=over 4

=item new

   new

=cut

sub new 
{
    my $class = shift;

    bless { @_ }, $class;
}

=item parse

my $xml = $ed->parse(text => <<XML);

=cut

sub parse
{
    require XML::ED::Bare;
    require XML::ED::Node;
    require XML::ED::NodeSet;
    my $self = shift;
    my %p = @_;

    my $text = delete $p{text};

    my ($a, $b) = XML::ED::Bare->new(text => $text);
    return $b;
}

1;

__END__

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

[30]    	ForwardAxis 	   ::=    	("child" "::")
| ("descendant" "::")
| ("attribute" "::")
| ("self" "::")
| ("descendant-or-self" "::")
| ("following-sibling" "::")
| ("following" "::")
| ("namespace" "::")
[33]    	ReverseAxis 	   ::=    	("parent" "::")
| ("ancestor" "::")
| ("preceding-sibling" "::")
| ("preceding" "::")
| ("ancestor-or-self" "::")


