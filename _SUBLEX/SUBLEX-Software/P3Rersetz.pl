# This script replaces umlaute and long vowels back into its original notation

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
if (/^(.*)/)
	{
	$zeil=$1;
	$zeil=~s/�/a:/g;
	$zeil=~s/�/E:/g;
	$zeil=~s/�/i:/g;
	$zeil=~s/�/o:/g;
	$zeil=~s/�/u:/g;
	$zeil=~s/�/y:/g;
	$zeil=~s/�/e:/g;
	$zeil=~s/�/&:/g;
	
	$zeil=~s/�/�/g;
	$zeil=~s/�/�/g;
	$zeil=~s/�/�/g;
	
	print OUT "$zeil\n";;	
	}




}

close IN;
close OUT;