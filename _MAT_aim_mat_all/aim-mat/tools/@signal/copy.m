% method of class @signal
% function sigresult=copy(sig1,sig2,[start_time])
% copies the first signal in the second, also when sig2 is a struct. 
%
%   INPUT VALUES:
%       sig1:       first @signal
%       sig2:       second @signal or struct
%       start_time: start time for copying. [default: 0]
%   RETURN VALUE:
%       sigresult:  @signal `
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=copy(a,b,start_time)

if nargin<3
    start_time=0;
end

if isobject(werte)
    not implemented yet
end

if isnumeric(b)
    sig=signal(a);
    sig=mute(sig);  % setze alle Werte auf Null
    
    nr=size(b,1);
    dauer=bin2time(sig,nr);
    
    sig=add(a,b,start_time,dauer)
end


   

