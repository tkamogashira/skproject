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


function [res,scaleinfo]=distributelogarithmic(from,to,steps)
% usage: [res,scaleinfo]=distributelogarithmic(from,to,steps)
% gives back values that start from "from" and go to "to" in 
% "steps" steps, so that the stepwidth is logarithmic

% returnvalues to keep track (needed in some cases)
scaleinfo.from=from;
scaleinfo.to=to;
scaleinfo.steps=steps;


res=0:steps-1;
res=lin2log(res,scaleinfo);
