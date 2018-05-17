% method of class @signal
% function [meansig,stdsig]=average(sig,[t_start],[t_stop])
% calculates the average value of the signal
%
%   INPUT VALUES:
%       sig:  original @signal
%       t_start: start time in seconds [0]
%       t_stop: stop time in seconds [getlength(sig)]
%    
%   RETURN VALUE:
%       meansig: mean value of the signal
%       stdsug: standart deviation
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function [meana,stda]=average(sig,t_start,t_stop)


if nargin < 2
    t_start=getminimumtime(sig);
end
if nargin < 3
    t_stop=t_start+getlength(sig);
end

intstart=time2bin(sig,t_start);
intstop=time2bin(sig,t_stop);

if intstart==0
    intstart=1;
end

if intstart>intstop
    error('signal::average: stoptime < starttime');
end


s=sig.werte(intstart:intstop);
if max(size(s))>1
    meana=mean(s);
    stda=std(s);
else
    meana=s;
    stda=0;
end    
