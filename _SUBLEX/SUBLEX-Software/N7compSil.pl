# This script compares the number of orthographic and phonological syllables, and excludes all entries at which the number of orthographic and phonological syllables do not match

#    This file is part of SUBLEX.
#    Copyright 2006 Markus Hofmann, SUBLEX v0.1

#    SUBLEX is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    SUBLEX is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with SUBLEX; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use Getopt::Std;
getopt ('i:o:a:');
open (IN,"$opt_i");
open (OUT,">$opt_o");
open (EX,">$opt_a");
$E=0;
while (<IN>)
{
	if (/^\d+\s(\D+)\s\d+\s(\D+)\s\d+$/)
	{
	$ortho=$1;
	$phono=$2;
	$ON=1;
	$PN=0;
	$ON++ while ($ortho = /[\-\=]/g);#{$ON++};
	$ON++ while ($ortho = /[^\d\[\]]\s[^\d\[\]]/g);#{$ON++};
	while ($phono = /\[/g){$PN++} 
	if ($PN ne $ON){print EX "$_";$E++}
	elsif ($PN eq $ON) {print OUT "$_";}
	}
}

close IN;
close OUT;
close EX;
print "In $opt_i rejected: $E by comparing syllable number\n";