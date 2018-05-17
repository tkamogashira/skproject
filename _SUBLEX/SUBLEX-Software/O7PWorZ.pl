# This script takes the phonological notatation
# and  writes each word of a word form database entry in one line with the appropriate frequency

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

# This script takes the orthographic notatation
# and  writes each syllable in one line with the appropriate frequency
use Getopt::Std;
getopt ('i:o:');
$n=0;
$wordn=0;
$dreier=0;
$zweier=0;
open (IN,"$opt_i");
open (OUT,">$opt_o");
while (<IN>)
{
if (/^(\d+)\s\D+\s(\d+)\s\[(\D+)\s\d+$/)
	{
 
	$n++;	
	$crit=$3;
	$Freq=$2;
	$numb=$1;

	$wordn++;
	
	if ($crit =~ /\]\s+\[\D+\]\s+\[\D+\]\s+/g)
		{print "ALAAAARM\n";}

       elsif ($crit =~ /\]\s+\[\D+\]\s+\[/g)
        {
 	$crit=~s/(\D+\])\s+(\[\D+\])\s+(\[\D+)/\1\t$Freq\n\2\t$Freq\n\3/g;
 	$wordn=$wordn+2;
        $dreier++;
        }

        elsif ($crit =~ /\]\s+\[/g)
        {
        print DEB "$crit\n";
        $crit=~s/\]\s\[/\t$Freq\n/g;
	$wordn++;
	$zweier++;
        }
        print OUT "$crit\t$Freq\n";
	}
}
close IN;
close OUT;
close DEB;
print " During shifting of entries into phonological words, $n entries were separated\n";
print " They were split into $wordn words\n";
print " $dreier phrases contained 3 words\n";
print " $zweier phrases contained 2 words\n";
