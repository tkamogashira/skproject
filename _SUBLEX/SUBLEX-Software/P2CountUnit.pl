# This script takes the sorted lists and counts the occurrences (type) of one type and sums its frequencies (token)

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

system "echo XX 0 >>$opt_i";

open(IN,"$opt_i");
open(OUT,">$opt_o");

$type="";
$token="";
$lastunit="Unit Type Token";
$start="XXX";
while (<IN>)

{
if (/^(\S+)\s+(\d+)/)
{
 	$unit=$1;
	$FreqUnit=$2;

	if (($unit eq $lastunit)||($lastunit eq $start ))
		{
		$type++;
		$token=$token+$FreqUnit;
		}

	elsif ($unit ne $lastunit)
		{
		print OUT "$lastunit $type $token\n";
		$type=1;
		$token=$FreqUnit;	
		}

	$lastunit=$1;

}
}
close IN;
close OUT;