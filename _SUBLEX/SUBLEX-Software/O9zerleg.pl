# This script decomposes words into its bigrams or biphonemes 

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
open (IN,"$opt_i");
open (OUT,">$opt_o");
while(<IN>)
{
if (/^(\D\D)\s(\d+)/)
{
print OUT "$1 $2\n";
}

elsif (/^(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $4\n";
print OUT "$2$3  $4\n";
}

elsif (/^(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $5\n";
print OUT "$2$3  $5\n";
print OUT "$3$4  $5\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $6\n";
print OUT "$2$3  $6\n";
print OUT "$3$4  $6\n";
print OUT "$4$5  $6\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $7\n";
print OUT "$2$3  $7\n";
print OUT "$3$4  $7\n";
print OUT "$4$5  $7\n";
print OUT "$5$6  $7\n";
}
elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $8\n";
print OUT "$2$3  $8\n";
print OUT "$3$4  $8\n";
print OUT "$4$5  $8\n";
print OUT "$5$6  $8\n";
print OUT "$6$7  $8\n";
}
elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $9\n";
print OUT "$2$3  $9\n";
print OUT "$3$4  $9\n";
print OUT "$4$5  $9\n";
print OUT "$5$6  $9\n";
print OUT "$6$7  $9\n";
print OUT "$7$8  $9\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $10\n";
print OUT "$2$3  $10\n";
print OUT "$3$4  $10\n";
print OUT "$4$5  $10\n";
print OUT "$5$6  $10\n";
print OUT "$6$7  $10\n";
print OUT "$7$8  $10\n";
print OUT "$8$9  $10\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $11\n";
print OUT "$2$3  $11\n";
print OUT "$3$4  $11\n";
print OUT "$4$5  $11\n";
print OUT "$5$6  $11\n";
print OUT "$6$7  $11\n";
print OUT "$7$8  $11\n";
print OUT "$8$9  $11\n";
print OUT "$9$10  $11\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $12\n";
print OUT "$2$3  $12\n";
print OUT "$3$4  $12\n";
print OUT "$4$5  $12\n";
print OUT "$5$6  $12\n";
print OUT "$6$7  $12\n";
print OUT "$7$8  $12\n";
print OUT "$8$9  $12\n";
print OUT "$9$10  $12\n";
print OUT "$10$11  $12\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $13\n";
print OUT "$2$3  $13\n";
print OUT "$3$4  $13\n";
print OUT "$4$5  $13\n";
print OUT "$5$6  $13\n";
print OUT "$6$7  $13\n";
print OUT "$7$8  $13\n";
print OUT "$8$9  $13\n";
print OUT "$9$10  $13\n";
print OUT "$10$11  $13\n";
print OUT "$11$12  $13\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $14\n";
print OUT "$2$3  $14\n";
print OUT "$3$4  $14\n";
print OUT "$4$5  $14\n";
print OUT "$5$6  $14\n";
print OUT "$6$7  $14\n";
print OUT "$7$8  $14\n";
print OUT "$8$9  $14\n";
print OUT "$9$10  $14\n";
print OUT "$10$11  $14\n";
print OUT "$11$12  $14\n";
print OUT "$12$13  $14\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $15\n";
print OUT "$2$3  $15\n";
print OUT "$3$4  $15\n";
print OUT "$4$5  $15\n";
print OUT "$5$6  $15\n";
print OUT "$6$7  $15\n";
print OUT "$7$8  $15\n";
print OUT "$8$9  $15\n";
print OUT "$9$10  $15\n";
print OUT "$10$11  $15\n";
print OUT "$11$12  $15\n";
print OUT "$12$13  $15\n";
print OUT "$13$14  $15\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $16\n";
print OUT "$2$3  $16\n";
print OUT "$3$4  $16\n";
print OUT "$4$5  $16\n";
print OUT "$5$6  $16\n";
print OUT "$6$7  $16\n";
print OUT "$7$8  $16\n";
print OUT "$8$9  $16\n";
print OUT "$9$10  $16\n";
print OUT "$10$11  $16\n";
print OUT "$11$12  $16\n";
print OUT "$12$13  $16\n";
print OUT "$13$14  $16\n";
print OUT "$14$15  $16\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $17\n";
print OUT "$2$3  $17\n";
print OUT "$3$4  $17\n";
print OUT "$4$5  $17\n";
print OUT "$5$6  $17\n";
print OUT "$6$7  $17\n";
print OUT "$7$8  $17\n";
print OUT "$8$9  $17\n";
print OUT "$9$10  $17\n";
print OUT "$10$11  $17\n";
print OUT "$11$12  $17\n";
print OUT "$12$13  $17\n";
print OUT "$13$14  $17\n";
print OUT "$14$15  $17\n";
print OUT "$15$16  $17\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $18\n";
print OUT "$2$3  $18\n";
print OUT "$3$4  $18\n";
print OUT "$4$5  $18\n";
print OUT "$5$6  $18\n";
print OUT "$6$7  $18\n";
print OUT "$7$8  $18\n";
print OUT "$8$9  $18\n";
print OUT "$9$10  $18\n";
print OUT "$10$11  $18\n";
print OUT "$11$12  $18\n";
print OUT "$12$13  $18\n";
print OUT "$13$14  $18\n";
print OUT "$14$15  $18\n";
print OUT "$15$16  $18\n";
print OUT "$16$17  $18\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $19\n";
print OUT "$2$3  $19\n";
print OUT "$3$4  $19\n";
print OUT "$4$5  $19\n";
print OUT "$5$6  $19\n";
print OUT "$6$7  $19\n";
print OUT "$7$8  $19\n";
print OUT "$8$9  $19\n";
print OUT "$9$10  $19\n";
print OUT "$10$11  $19\n";
print OUT "$11$12  $19\n";
print OUT "$12$13  $19\n";
print OUT "$13$14  $19\n";
print OUT "$14$15  $19\n";
print OUT "$15$16  $19\n";
print OUT "$16$17  $19\n";
print OUT "$17$18  $19\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $20\n";
print OUT "$2$3  $20\n";
print OUT "$3$4  $20\n";
print OUT "$4$5  $20\n";
print OUT "$5$6  $20\n";
print OUT "$6$7  $20\n";
print OUT "$7$8  $20\n";
print OUT "$8$9  $20\n";
print OUT "$9$10  $20\n";
print OUT "$10$11  $20\n";
print OUT "$11$12  $20\n";
print OUT "$12$13  $20\n";
print OUT "$13$14  $20\n";
print OUT "$14$15  $20\n";
print OUT "$15$16  $20\n";
print OUT "$16$17  $20\n";
print OUT "$17$18  $20\n";
print OUT "$18$19  $20\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $21\n";
print OUT "$2$3  $21\n";
print OUT "$3$4  $21\n";
print OUT "$4$5  $21\n";
print OUT "$5$6  $21\n";
print OUT "$6$7  $21\n";
print OUT "$7$8  $21\n";
print OUT "$8$9  $21\n";
print OUT "$9$10  $21\n";
print OUT "$10$11  $21\n";
print OUT "$11$12  $21\n";
print OUT "$12$13  $21\n";
print OUT "$13$14  $21\n";
print OUT "$14$15  $21\n";
print OUT "$15$16  $21\n";
print OUT "$16$17  $21\n";
print OUT "$17$18  $21\n";
print OUT "$18$19  $21\n";
print OUT "$19$20  $21\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $22\n";
print OUT "$2$3  $22\n";
print OUT "$3$4  $22\n";
print OUT "$4$5  $22\n";
print OUT "$5$6  $22\n";
print OUT "$6$7  $22\n";
print OUT "$7$8  $22\n";
print OUT "$8$9  $22\n";
print OUT "$9$10  $22\n";
print OUT "$10$11  $22\n";
print OUT "$11$12  $22\n";
print OUT "$12$13  $22\n";
print OUT "$13$14  $22\n";
print OUT "$14$15  $22\n";
print OUT "$15$16  $22\n";
print OUT "$16$17  $22\n";
print OUT "$17$18  $22\n";
print OUT "$18$19  $22\n";
print OUT "$19$20  $22\n";
print OUT "$20$21  $22\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $23\n";
print OUT "$2$3  $23\n";
print OUT "$3$4  $23\n";
print OUT "$4$5  $23\n";
print OUT "$5$6  $23\n";
print OUT "$6$7  $23\n";
print OUT "$7$8  $23\n";
print OUT "$8$9  $23\n";
print OUT "$9$10  $23\n";
print OUT "$10$11  $23\n";
print OUT "$11$12  $23\n";
print OUT "$12$13  $23\n";
print OUT "$13$14  $23\n";
print OUT "$14$15  $23\n";
print OUT "$15$16  $23\n";
print OUT "$16$17  $23\n";
print OUT "$17$18  $23\n";
print OUT "$18$19  $23\n";
print OUT "$19$20  $23\n";
print OUT "$20$21  $23\n";
print OUT "$21$22  $23\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $24\n";
print OUT "$2$3  $24\n";
print OUT "$3$4  $24\n";
print OUT "$4$5  $24\n";
print OUT "$5$6  $24\n";
print OUT "$6$7  $24\n";
print OUT "$7$8  $24\n";
print OUT "$8$9  $24\n";
print OUT "$9$10  $24\n";
print OUT "$10$11  $24\n";
print OUT "$11$12  $24\n";
print OUT "$12$13  $24\n";
print OUT "$13$14  $24\n";
print OUT "$14$15  $24\n";
print OUT "$15$16  $24\n";
print OUT "$16$17  $24\n";
print OUT "$17$18  $24\n";
print OUT "$18$19  $24\n";
print OUT "$19$20  $24\n";
print OUT "$20$21  $24\n";
print OUT "$21$22  $24\n";
print OUT "$22$23  $24\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $25\n";
print OUT "$2$3  $25\n";
print OUT "$3$4  $25\n";
print OUT "$4$5  $25\n";
print OUT "$5$6  $25\n";
print OUT "$6$7  $25\n";
print OUT "$7$8  $25\n";
print OUT "$8$9  $25\n";
print OUT "$9$10  $25\n";
print OUT "$10$11  $25\n";
print OUT "$11$12  $25\n";
print OUT "$12$13  $25\n";
print OUT "$13$14  $25\n";
print OUT "$14$15  $25\n";
print OUT "$15$16  $25\n";
print OUT "$16$17  $25\n";
print OUT "$17$18  $25\n";
print OUT "$18$19  $25\n";
print OUT "$19$20  $25\n";
print OUT "$20$21  $25\n";
print OUT "$21$22  $25\n";
print OUT "$22$23  $25\n";
print OUT "$23$24  $25\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $26\n";
print OUT "$2$3  $26\n";
print OUT "$3$4  $26\n";
print OUT "$4$5  $26\n";
print OUT "$5$6  $26\n";
print OUT "$6$7  $26\n";
print OUT "$7$8  $26\n";
print OUT "$8$9  $26\n";
print OUT "$9$10  $26\n";
print OUT "$10$11  $26\n";
print OUT "$11$12  $26\n";
print OUT "$12$13  $26\n";
print OUT "$13$14  $26\n";
print OUT "$14$15  $26\n";
print OUT "$15$16  $26\n";
print OUT "$16$17  $26\n";
print OUT "$17$18  $26\n";
print OUT "$18$19  $26\n";
print OUT "$19$20  $26\n";
print OUT "$20$21  $26\n";
print OUT "$21$22  $26\n";
print OUT "$22$23  $26\n";
print OUT "$23$24  $26\n";
print OUT "$24$25  $26\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $27\n";
print OUT "$2$3  $27\n";
print OUT "$3$4  $27\n";
print OUT "$4$5  $27\n";
print OUT "$5$6  $27\n";
print OUT "$6$7  $27\n";
print OUT "$7$8  $27\n";
print OUT "$8$9  $27\n";
print OUT "$9$10  $27\n";
print OUT "$10$11  $27\n";
print OUT "$11$12  $27\n";
print OUT "$12$13  $27\n";
print OUT "$13$14  $27\n";
print OUT "$14$15  $27\n";
print OUT "$15$16  $27\n";
print OUT "$16$17  $27\n";
print OUT "$17$18  $27\n";
print OUT "$18$19  $27\n";
print OUT "$19$20  $27\n";
print OUT "$20$21  $27\n";
print OUT "$21$22  $27\n";
print OUT "$22$23  $27\n";
print OUT "$23$24  $27\n";
print OUT "$24$25  $27\n";
print OUT "$25$26  $27\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $28\n";
print OUT "$2$3  $28\n";
print OUT "$3$4  $28\n";
print OUT "$4$5  $28\n";
print OUT "$5$6  $28\n";
print OUT "$6$7  $28\n";
print OUT "$7$8  $28\n";
print OUT "$8$9  $28\n";
print OUT "$9$10  $28\n";
print OUT "$10$11  $28\n";
print OUT "$11$12  $28\n";
print OUT "$12$13  $28\n";
print OUT "$13$14  $28\n";
print OUT "$14$15  $28\n";
print OUT "$15$16  $28\n";
print OUT "$16$17  $28\n";
print OUT "$17$18  $28\n";
print OUT "$18$19  $28\n";
print OUT "$19$20  $28\n";
print OUT "$20$21  $28\n";
print OUT "$21$22  $28\n";
print OUT "$22$23  $28\n";
print OUT "$23$24  $28\n";
print OUT "$24$25  $28\n";
print OUT "$25$26  $28\n";
print OUT "$26$27  $28\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $29\n";
print OUT "$2$3  $29\n";
print OUT "$3$4  $29\n";
print OUT "$4$5  $29\n";
print OUT "$5$6  $29\n";
print OUT "$6$7  $29\n";
print OUT "$7$8  $29\n";
print OUT "$8$9  $29\n";
print OUT "$9$10  $29\n";
print OUT "$10$11  $29\n";
print OUT "$11$12  $29\n";
print OUT "$12$13  $29\n";
print OUT "$13$14  $29\n";
print OUT "$14$15  $29\n";
print OUT "$15$16  $29\n";
print OUT "$16$17  $29\n";
print OUT "$17$18  $29\n";
print OUT "$18$19  $29\n";
print OUT "$19$20  $29\n";
print OUT "$20$21  $29\n";
print OUT "$21$22  $29\n";
print OUT "$22$23  $29\n";
print OUT "$23$24  $29\n";
print OUT "$24$25  $29\n";
print OUT "$25$26  $29\n";
print OUT "$26$27  $29\n";
print OUT "$27$28  $29\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $30\n";
print OUT "$2$3  $30\n";
print OUT "$3$4  $30\n";
print OUT "$4$5  $30\n";
print OUT "$5$6  $30\n";
print OUT "$6$7  $30\n";
print OUT "$7$8  $30\n";
print OUT "$8$9  $30\n";
print OUT "$9$10  $30\n";
print OUT "$10$11  $30\n";
print OUT "$11$12  $30\n";
print OUT "$12$13  $30\n";
print OUT "$13$14  $30\n";
print OUT "$14$15  $30\n";
print OUT "$15$16  $30\n";
print OUT "$16$17  $30\n";
print OUT "$17$18  $30\n";
print OUT "$18$19  $30\n";
print OUT "$19$20  $30\n";
print OUT "$20$21  $30\n";
print OUT "$21$22  $30\n";
print OUT "$22$23  $30\n";
print OUT "$23$24  $30\n";
print OUT "$24$25  $30\n";
print OUT "$25$26  $30\n";
print OUT "$26$27  $30\n";
print OUT "$27$28  $30\n";
print OUT "$28$29  $30\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $31\n";
print OUT "$2$3  $31\n";
print OUT "$3$4  $31\n";
print OUT "$4$5  $31\n";
print OUT "$5$6  $31\n";
print OUT "$6$7  $31\n";
print OUT "$7$8  $31\n";
print OUT "$8$9  $31\n";
print OUT "$9$10  $31\n";
print OUT "$10$11  $31\n";
print OUT "$11$12  $31\n";
print OUT "$12$13  $31\n";
print OUT "$13$14  $31\n";
print OUT "$14$15  $31\n";
print OUT "$15$16  $31\n";
print OUT "$16$17  $31\n";
print OUT "$17$18  $31\n";
print OUT "$18$19  $31\n";
print OUT "$19$20  $31\n";
print OUT "$20$21  $31\n";
print OUT "$21$22  $31\n";
print OUT "$22$23  $31\n";
print OUT "$23$24  $31\n";
print OUT "$24$25  $31\n";
print OUT "$25$26  $31\n";
print OUT "$26$27  $31\n";
print OUT "$27$28  $31\n";
print OUT "$28$29  $31\n";
print OUT "$29$30  $31\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $32\n";
print OUT "$2$3  $32\n";
print OUT "$3$4  $32\n";
print OUT "$4$5  $32\n";
print OUT "$5$6  $32\n";
print OUT "$6$7  $32\n";
print OUT "$7$8  $32\n";
print OUT "$8$9  $32\n";
print OUT "$9$10  $32\n";
print OUT "$10$11  $32\n";
print OUT "$11$12  $32\n";
print OUT "$12$13  $32\n";
print OUT "$13$14  $32\n";
print OUT "$14$15  $32\n";
print OUT "$15$16  $32\n";
print OUT "$16$17  $32\n";
print OUT "$17$18  $32\n";
print OUT "$18$19  $32\n";
print OUT "$19$20  $32\n";
print OUT "$20$21  $32\n";
print OUT "$21$22  $32\n";
print OUT "$22$23  $32\n";
print OUT "$23$24  $32\n";
print OUT "$24$25  $32\n";
print OUT "$25$26  $32\n";
print OUT "$26$27  $32\n";
print OUT "$27$28  $32\n";
print OUT "$28$29  $32\n";
print OUT "$29$30  $32\n";
print OUT "$30$31  $32\n";
}

elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $33\n";
print OUT "$2$3  $33\n";
print OUT "$3$4  $33\n";
print OUT "$4$5  $33\n";
print OUT "$5$6  $33\n";
print OUT "$6$7  $33\n";
print OUT "$7$8  $33\n";
print OUT "$8$9  $33\n";
print OUT "$9$10  $33\n";
print OUT "$10$11  $33\n";
print OUT "$11$12  $33\n";
print OUT "$12$13  $33\n";
print OUT "$13$14  $33\n";
print OUT "$14$15  $33\n";
print OUT "$15$16  $33\n";
print OUT "$16$17  $33\n";
print OUT "$17$18  $33\n";
print OUT "$18$19  $33\n";
print OUT "$19$20  $33\n";
print OUT "$20$21  $33\n";
print OUT "$21$22  $33\n";
print OUT "$22$23  $33\n";
print OUT "$23$24  $33\n";
print OUT "$24$25  $33\n";
print OUT "$25$26  $33\n";
print OUT "$26$27  $33\n";
print OUT "$27$28  $33\n";
print OUT "$28$29  $33\n";
print OUT "$29$30  $33\n";
print OUT "$30$31  $33\n";
print OUT "$31$32  $33\n";
}
elsif (/^(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)(\D)\s(\d+)/)
{
print OUT "$1$2  $34\n";
print OUT "$2$3  $34\n";
print OUT "$3$4  $34\n";
print OUT "$4$5  $34\n";
print OUT "$5$6  $34\n";
print OUT "$6$7  $34\n";
print OUT "$7$8  $34\n";
print OUT "$8$9  $34\n";
print OUT "$9$10  $34\n";
print OUT "$10$11  $34\n";
print OUT "$11$12  $34\n";
print OUT "$12$13  $34\n";
print OUT "$13$14  $34\n";
print OUT "$14$15  $34\n";
print OUT "$15$16  $34\n";
print OUT "$16$17  $34\n";
print OUT "$17$18  $34\n";
print OUT "$18$19  $34\n";
print OUT "$19$20  $34\n";
print OUT "$20$21  $34\n";
print OUT "$21$22  $34\n";
print OUT "$22$23  $34\n";
print OUT "$23$24  $34\n";
print OUT "$24$25  $34\n";
print OUT "$25$26  $34\n";
print OUT "$26$27  $34\n";
print OUT "$27$28  $34\n";
print OUT "$28$29  $34\n";
print OUT "$29$30  $34\n";
print OUT "$30$31  $34\n";
print OUT "$31$32  $34\n";
print OUT "$32$33  $34\n";
}
#else {print "No match found for: $_";}
}
close IN;
close OUT;

