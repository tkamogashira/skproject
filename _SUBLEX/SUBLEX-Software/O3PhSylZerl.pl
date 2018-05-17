# This script takes the phonological notatation
# and  writes each syllable in one line with the appropriate frequency

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
$n=0;
open (IN,"$opt_i");
open (OUT,">$opt_o");
while (<IN>)
{
if (/^\d+\s\D+\s(\d+)\s\[(\D+)\s\d+$/)
	{$n++;
	$Freq=$1;
	$crit=$2;
	$crit=~s/([^\[\]]+)\[([^\[\]])\]([^\[\]]+)\]/\1\2\t$Freq\n\2\3\t$Freq\n/;
  	$crit=~s/\]/\t$Freq\n/g;
	$crit=~s/\[//g;
	$crit=~s/ //g;
	print OUT "$crit";
	}
}
print "$n\n";
close IN;
close OUT;


