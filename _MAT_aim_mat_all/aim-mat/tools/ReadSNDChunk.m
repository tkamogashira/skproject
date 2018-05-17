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
% File:			Read16Bits.m
% Purpose:		Read two 8 bit bytes and combine according to the machine's
%				endian architecture.
% Comments:	
% Author:		L. P. O'Mard
% Revised by:
% Created:
% Updated:
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data=Read16Bits(fid, littleEndian)

first = fread(fid, 1, 'uint8');
second = fread(fid, 1, 'uint8');
if (littleEndian ~= 0)
	data = bitshift(first, 8) + second;
else
	data = bitshift(second, 8) + first;
end;
