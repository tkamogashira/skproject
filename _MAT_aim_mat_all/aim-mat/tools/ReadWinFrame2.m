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
% File:			ReadWinFrame2.m
% Purpose:		Reads a window from from an AIFF file.
% Comments:	
% Author:		L. P. O'Mard
% Revised by:		M.Tsuzaki	(ATR SLT)
% Created:
% Updated:		31,Oct.,2001
% Copyright:	(c) 2000, University of Essex
% changed by Stefan Bleeck to produce stars
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $
function signal=ReadWinFrame2(fid, frameId, numWindowFrames, numChannels, frameLen, wordSize,echo)
if nargin < 7
    echo=1
end
p_bias = ftell(fid);
if numWindowFrames == 1
	top = frameId(1);
	if length(frameId) > 1
		bot = frameId(end);
	else
		bot = frameLen;
	end
else
	frameId=frameId(find(frameId>=1 & frameId<=numWindowFrames));
end
if isempty(frameId)
    warning(sprintf('FrameID should be in the range of [1 %d]',numWindowFrames));
    signal = [];
    return
end
switch wordSize
	case 1
	   if numWindowFrames == 1
		fseek(fid,top-1,'cof');
		nn = bot - top + 1;
		signal = fread(fid, [numChannels, nn], 'char');
	   else
		for kk=1:length(frameId)
		    fseek(fid,p_bais+(frameId(kk)-1)*numChannels*frameLen,'bof');
		    signal(:,:,kk)=fread(fid,[numChannels, frameLen],'char');
		end
	   end
	case 2
	   if numWindowFrames == 1
		fseek(fid,2*(top-1),'cof');
		nn = bot - top + 1;
		signal = fread(fid,[numChannels, nn], 'short');
	   else
		for kk=1:length(frameId)
            if echo fprintf('*'); end
              
		    fseek(fid,p_bias+2*(frameId(kk)-1)*numChannels*frameLen,'bof');
		    signal(:,:,kk)=fread(fid,[numChannels, frameLen],'short');
% 		    signal(:,:,kk)=fread(fid,[numChannels, frameLen],'int');
		end
	   end
	case 4
	   if numWindowFrames == 1
		fseek(fid,4*(top-1),'cof');
		nn = bot - top + 1;
%		signal = fread(fid,[numChannels, nn], 'float32');
		signal = fread(fid,[numChannels, nn], 'uint32');
	   else
		for kk=1:length(frameId)
		    fseek(fid,p_bias+4*(frameId(kk)-1)*numChannels*frameLen,'bof');
%		    signal(:,:,kk)=fread(fid,[numChannels, frameLen],'float32');
		    signal(:,:,kk)=fread(fid,[numChannels, frameLen],'uint32');
		end
	   end
	
end
