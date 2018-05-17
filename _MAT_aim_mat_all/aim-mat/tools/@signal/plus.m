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


function sig=plus(a,b)
% addition 
% einfachster Fall: Addiere eine konstante Zahl
% sonst: Addiere ein zweites Signal zum Zeitpunkt Null

if isnumeric(b)
    a.werte=a.werte+b;
    sig=a;
    return
end

if isobject(a)
    dauer=getlength(b);
    start=getminimumtime(a);
    sig=add(a,b,start,dauer);
end