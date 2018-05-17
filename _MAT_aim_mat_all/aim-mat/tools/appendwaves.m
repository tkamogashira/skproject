% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sumwaves = appendwaves (varargin)

numwav=length(varargin);

for i=1:numwav
    sig(i)=loadwavefile(signal,varargin{i});
end

sumwaves=sig(1);
for i=2:numwav
    sumwaves=append(sumwaves,sig(i));
end
