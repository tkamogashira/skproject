# This script annilihates all Separators [, ], -, and =

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
if (/^(.*)$/)
	{	
	$crit=$1;
	$crit=~s/[\]\[\-\=]//g;
	$crit=~s/ ([^\d])/\1/g;
	print OUT "$crit\n";
	}
}
close IN;
close OUT;


