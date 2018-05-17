% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function x=solve(p,y)
% solves the polynom p for the value at y
%
%   INPUT VALUES:
% input: a polynom
%  
%   RETURN VALUE:
% return value(s) are the values, where the polynom is equal the
% y-value
%

p(end)=p(end)-y;
x=roots(p);
