% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ret=SBReadAiff(aifffile,echo)
% usage SBReadAiff(aifffile,echo)
%   
% returns all info in a struct
% if echo =0, than no screen output is created
if nargin<2
    echo=1;
end


aiffstruct=getAIFFinfo(aifffile);
if echo
fprintf('read %d frames with %d channels...',aiffstruct.numWindowFrames,aiffstruct.numChannels);end

ende=0;
n=0;
nap=zeros(aiffstruct.numChannels,aiffstruct.frameLength,aiffstruct.numWindowFrames);

if aiffstruct.littleEndian
    fid=fopen(aifffile,'r','l');
else
    fid=fopen(aifffile,'r','b');
end

while ~ende
    von=n*30+1;
    bis=(n+1)*30;
    n=n+1;
    if bis>aiffstruct.numWindowFrames
        bis=aiffstruct.numWindowFrames;
        ende=1;
    end
    
    status = fseek(fid, aiffstruct.soundPosition, 'bof');
    tnap = ReadWinFrame2(fid, von:bis, aiffstruct.numWindowFrames,...
        aiffstruct.numChannels,aiffstruct.frameLength, aiffstruct.wordSize,echo);
    
    if bis>=aiffstruct.numWindowFrames;
        ende=1;    
    end
    
    if echo
    fprintf('\n');    end
        
    tnap = tnap .* aiffstruct.scale;
    
    %     tnap = myReadAIFF(aifffile,von:bis);
    nap(:,:,von:bis)=tnap;
end

[nr_channels,nr_points,nr_frames]=size(nap);

high=-inf;low=inf;
sumhigh=-inf;
frehigh=-inf;
% do some controlling of the values
for i=1:nr_frames
    vals=nap(:,:,i);
    fr=frame(vals,aiffstruct);  % construct the frame
    ret(i)=fr;
    
    % find the maximum and the minimum values of each frame. this is useful for scaling
    ma=getmaximumvalue(fr);
    high=max([high ma]);
    mi=getminimumvalue(fr);
    low=min([low mi]);
    
    
    maxs=max(getsum(fr));
    sumhigh=max([maxs sumhigh]);
    
    maxf=max(getfrequencysum(fr));
    frehigh=max([maxf frehigh]);

end

% sr=getsr(ret(1));

for i=1:nr_frames
    ret(i)=setallmaxvalue(ret(i),high); 
    ret(i)=setallminvalue(ret(i),low); 
    ret(i)=setnrframestotal(ret(i),nr_frames); 
    ret(i)=setscalesumme(ret(i),sumhigh); 
    ret(i)=setscalefrequency(ret(i),frehigh); 
    ret(i)=setcurrentframenumber(ret(i),i);
    frame_duration=aiffstruct.frameLength/aiffstruct.sampleRate;
    ret(i)=setcurrentframestarttime(ret(i),(i-1)*frame_duration);
end
