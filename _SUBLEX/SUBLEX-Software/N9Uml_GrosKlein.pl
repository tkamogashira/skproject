# This script transforms German "umlaute" in characters that can be processed with this program (based on the character set of OsX).

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
getopt ('i:o:');


print "jo\n";

open(IN,"$opt_i");
open(OUT,">$opt_o");

while(<IN>)
{

	if (/^(\d+\s)(.+)(\s\d+\s\D+\s\d+)$/)
	{
	$eins=$1;
	$zeil=$2;
	$drei=$3;

	$zeil=~tr/A-Z/a-z/;
	$zeil=~s/"a/ä/g;
	$zeil=~s/"u/ü/g;
	$zeil=~s/"o/ö/g;

	print OUT "$eins$zeil$drei\n";
	}

else {print "Error in $_";}

}
close IN;
close OUT;