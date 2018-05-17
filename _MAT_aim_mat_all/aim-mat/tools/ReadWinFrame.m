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
% File:			ReadWinFrame.m
% Purpose:		Reads a window from from an AIFF file.
% Comments:	
% Author:		L. P. O'Mard
% Revised by:
% Created:
% Updated:
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function frame=ReadWinFrame(fid, numChannels, frameLen, wordSize, littleEndian)

switch wordSize
	case 1
		frame = fread(fid, [numChannels, frameLen], 'char');
	case 2
		for i = 1:frameLen
			for j = 1:numChannels
				data = Read16Bits(fid, littleEndian);
				if (data >= 32768)
					frame(j, i) = data - 65536;
				else
					frame(j, i) = data;
				end
			end;
		end;
	case 4
		for i = 1:frameLen
			for j = 1:numChannels
				data = Read32Bits(fid, littleEndian);
				if (data >= 2147483648)
					frame(j, i) = data - 4294967296;
				else
					frame(j, i) = data;
				end
			end;
		end;
	
end

