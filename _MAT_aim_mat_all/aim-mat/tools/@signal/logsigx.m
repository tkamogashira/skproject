% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function [lsig,scaleinfo]=logsigx(sig,tmin,tmax,nr_points)
% usage: [lsig,scaler]=logsigx(sig,tmin,tmax,nr_points)
% transferes the signal to a signal that is in logarithmic scale
% so plotting the original signal logarithmic is identical to
% plot the transfered signal linear
% uses only the part of the signal between tmin and tmax
%
% reverse operation: linsigx(sig,tmin,tmax,nr_points)


if nargin < 4
    nr_points=getnrpoints(sig);
end
if nargin<3
    tmax=getmaximumtime(sig);
end
if nargin<2
    tmin=getminimumtime(sig);
end
if tmin==0
    tmin=1/getsr(sig);
end


oldvals=getvalues(sig);
newvals=zeros(nr_points,1);


[ntimes,scaleinfo]=distributelogarithmic(tmin,tmax,nr_points);
newvals=gettimevalue(sig,ntimes);
if isnan(newvals(1))
    newvals(1)=0;
end

lsig=sig;    % copy all values
lsig=setvalues(lsig,newvals,1);

lsig=setnrxticks(lsig,6);
l=distributelogarithmic(tmin,tmax,6);

l=round(l*10000)/10;

lsig=setxlabels(lsig,l);

