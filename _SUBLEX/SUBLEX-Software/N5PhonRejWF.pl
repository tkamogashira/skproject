# This Script excludes all foreign words from analysis based on the phonological notation of the CELEX's word form database.

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
getopt ('i:o:a');
open (IN, "$opt_i");
open (OUT, ">$opt_o");
open (AUS, ">$opt_a");

while (<IN>)
{
if (/^.*\~.*/) # nasal
	{
	print AUS "$_";
	}

elsif (/^.*A.*$/)# A - advantage
        {
        print AUS "$_";
        }
elsif (/^.*Z.*$/) # # bu/dg/et 
        {
        print AUS "$_";
        }
elsif (/^.*O\:.*$/)# /A/llround
        {
        print AUS "$_";
        }
elsif (/^.*V.*/)# pl/u/mpudding
        {
        print AUS "$_";
        }
elsif (/^.*w.*/) # team/w/ork, damit auch 3: t/ea/mwork
        {
        print AUS "$_";
  	}

elsif (/^\S+\s+\S*&[^:]\S*\s+\d+/) # playback
        {
        print AUS "$_";
        }

elsif (/^\S+\s+\S*e[^:]\S*\s+\d+/) # n/a/tive
        {
        print AUS "$_";
        }

else {print OUT "$_";}
}
close IN;
close AUS;
close OUT;
