% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File:			Read32Bits.m
% Purpose:		Read four 8 bit bytes and combine according to the machine's
%				endian architecture.
% Comments:	
% Author:		L. P. O'Mard
% Revised by:
% Created:
% Updated:
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data=Read32Bits(fid, littleEndian)

first = Read16Bits(fid, littleEndian);
second = Read16Bits(fid, littleEndian);
if (littleEndian == 0)
	data = bitshift(first, 16) + second;
else
	data = bitshift(second, 16) + first;
end;
