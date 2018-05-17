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


function linsig=linsigx(sig)
% usage: linsig=linsigx(sig)
% transferes the signal from a signal that is in logarithmic scale
% to a signal, that is in linear scale.
% reverser operation from logsinx
%
% this is a little bit tricky since we cant take the times as measure for
% the logarithmic part. We therefore take the labels, which must be defined
% properly!

if length(sig.x_tick_labels) > 0
    tmin=sig.x_tick_labels(1)/1000;
    tmax=sig.x_tick_labels(end)/1000;
%     tmin=sig.x_tick_labels(1);
%     tmax=sig.x_tick_labels(end);
else
    error('signal::linsig: definie x labels of signal');
end

nr_points=getnrpoints(sig);

oldvals=getvalues(sig);
newvals=zeros(nr_points,1);


% [ntimes,scaleinfo]=distributelogarithmic(tmin,tmax,nr_points);
ntimes=linspace(tmin,tmax,nr_points);
mtimes=f2f(ntimes,0.001,0.035,0.001,0.035,'loglin');
% mtimes=f2f(ntimes,tmin,tmax,tmin,tmax,'loglin');
newvals=gettimevalue(sig,mtimes);

sr=nr_points/(tmax-tmin);
linsig=signal(newvals,sr);    % copy all values
linsig=setstarttime(linsig,tmin);


