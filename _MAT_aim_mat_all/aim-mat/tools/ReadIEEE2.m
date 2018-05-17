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
% File:			ReadIEEE.m
% Purpose:		Reads an IEEE float from a file.
% Comments:		The calculation is for big-endian format, so little-endian must
%				be converted to big-endian format.
% Author:		L. P. O'Mard
% Revised by:
% Created:
% Updated:
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function value = ReadIEEE(fid, littleEndian);

if littleEndian == 0
	swapBytes = 0;
else
	swapBytes = 1;
end;
bytes = ReadBytes(fid, 10, swapBytes);

expon = bitand(bytes(1), 127) * 2^8 + bytes(2);
hiMant = bytes(3) * 2^24 + bytes(4) * 2^16 + bytes(5) * 2^8 + bytes(6);
loMant = bytes(7) * 2^24 + bytes(8) * 2^16 + bytes(9) * 2^8 + bytes(10);
expon = expon - 16383;
value = hiMant * 2^(expon - 31);
expon = expon - 31;
value = value + (loMant * 2^(expon - 32));

if bitand(bytes(1), 128) ~= 0
	value = -value;
end;
