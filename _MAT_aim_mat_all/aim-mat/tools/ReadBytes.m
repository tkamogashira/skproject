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
% File:			ReadBytes.m
% Purpose:		Reads a number of bytes from file.
% Comments:	
% Author:		L. P. O'Mard
% Revised by:
% Created:
% Updated:
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bytes = ReadBytes(fid, n, swapBytes)

bytes=fread(fid, n, 'char');

if (swapBytes ~= 0)
	for i = 1:n/2
		temp = bytes(i);
		swapIndex = n - i + 1;
		bytes(i) = bytes(swapIndex);
		bytes(swapIndex) = temp;
	end;
end;

