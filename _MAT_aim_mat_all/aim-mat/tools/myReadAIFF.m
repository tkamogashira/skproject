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
% File:			ReadAIFF.m
% Purpose:		Reads an AIFF format file.
% Comments:		The default binary format is big-endian, if this does not
%				work, then little-endian format is tried.
% Author:		L. P. O'Mard
% Revised by:		M.Tsuzaki
% Created:
% Updated:		31,Oct.2001
% Copyright:	(c) 2000, University of Essex
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signal = myReadAIFF(fname,frameId)
if nargin < 2
    frameId=1:10000; %default: read to end
end
absoluteNormalise = 1.0;
[fid, msg] = fopen(fname);
if fid == -1
    error('File open error. Please check that the file name is correctly spelled.')
end
littleEndian = 0;
aiff_form = ReadBytes(fid, 4, littleEndian);
if aiff_form' == double('FORM')
%	disp('big-endian');
else
%	disp('little-endian');
	littleEndian = 1;
end;
chunkSize = Read32Bits(fid, littleEndian);
aiff_aiff = ReadBytes(fid, 4, littleEndian);
if aiff_aiff' ~= double('AIFF')
	aiff_aiff
	disp('Not a valid AIFF file.');
	return
end;
chunkSize = chunkSize - 16;
while chunkSize - 4 > 0;
	chunkName = ReadBytes(fid, 4, littleEndian);
	chunkSize = chunkSize - 4;
	if chunkName' == double('COMM');
% 		disp('step COMM');
 		subSize = Read32Bits(fid, littleEndian);
 		chunkSize = chunkSize-subSize;
 		numChannels = Read16Bits(fid, littleEndian);
 		subSize = subSize - 2;
 		numSampleFrames = Read32Bits(fid, littleEndian);
 		subSize = subSize - 4; 
 		sampleSize = Read16Bits(fid, littleEndian);
 		subSize = subSize - 2;
 		sampleRate = ReadIEEE(fid, littleEndian);
 		subSize = subSize - 10;
 		fread(fid, subSize, 'char');
	elseif chunkName' == double('SSND');
% 		disp('step SSND');
 		subSize = Read32Bits(fid, littleEndian);
 		chunkSize = chunkSize - subSize;
 		offset = Read32Bits(fid, littleEndian);
		subSize = subSize - 4;
		blockSize = Read32Bits(fid, littleEndian);
		subSize = subSize - 4;
		soundPosition = ftell(fid) + offset;
		fread(fid, subSize, 'char');
	elseif chunkName' == double('LUT2');
% 		disp('step LUT2');
 		subSize = Read32Bits(fid, littleEndian);
 		chunkSize = chunkSize - subSize;
 		interleaveLevel = Read16Bits(fid, littleEndian);
 		subSize = subSize - 2;
  		numWindowFrames = Read16Bits(fid, littleEndian);
 		subSize = subSize - 2;
  		staticTimeFlag = Read16Bits(fid, littleEndian);
 		subSize = subSize - 2;
		outputTimeOffset = ReadIEEE(fid, littleEndian);
 		subSize = subSize - 10;
 		absoluteNormalise = ReadIEEE(fid, littleEndian);
 		subSize = subSize - 10;
 		fread(fid, subSize, 'char');
		
 	else;
 		subSize = Read32Bits(fid, littleEndian);
 		chunkSize = chunkSize - subSize;
 		fread(fid, subSize, 'char');
 			
 	end;
end;
wordSize = floor((sampleSize + 7 ) / 8);
normalise = (2^16 - 1) / 2^(17 - wordSize * 8) / absoluteNormalise;
switch wordSize
	case 1, scale = normalise / 127.0;
	case 2, scale = normalise / 32768.0;
	case 4, scale = normalise / 32768.0 / 65536;
end
frameLength = numSampleFrames / numWindowFrames;
% signal = zeros(numChannels,frameLength, numWindowFrames);
fclose(fid);
if littleEndian
	fopen(fname,'r','l');
%	disp('open as little endian')
else
	fopen(fname,'r','b');
%	disp('open as big endian')
end
status = fseek(fid, soundPosition, 'bof');
% disp( [frameId numWindowFrames numChannels frameLength wordSize])
signal = ReadWinFrame2(fid, frameId, numWindowFrames, numChannels,frameLength, wordSize);
signal = signal .* scale;
status = fclose(fid);
