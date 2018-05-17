# This script decomposes words in its single units

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
open(IN,"$opt_i");
open(OUT,">$opt_o");
while(<IN>)
{
if (/^(\S+)\s+(\d+)/)
	{	
	$stim=$1;
	$freq=$2;
	$stim=~s/(\S)/\1\t$freq\n/g;
	print OUT "$stim";
	}

}

close IN;
close OUT;