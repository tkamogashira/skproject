% method of class @signal
%
% returns the height and lows in locations and time of all local maxima in the signal
% in case of continuus maxima, the last value of the series is taken
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


function [maxpos,minpos,maxs,mins]=getminmax(sig)
% usage: [maxpos,minpos,maxs,mins]=getminmax(sig)


werte=getdata(sig);
werte=werte';

% find all maxima
% mit NULL!!
maxpos = find((werte >= [0 werte(1:end-1)]) & (werte > [werte(2:end) 0]));
maxs=werte(maxpos);

% find all minima
minpos = find((werte < [inf werte(1:end-1)]) & (werte <= [werte(2:end) inf]));
mins=werte(minpos);

maxpos=bin2time(sig,maxpos);
minpos=bin2time(sig,minpos);