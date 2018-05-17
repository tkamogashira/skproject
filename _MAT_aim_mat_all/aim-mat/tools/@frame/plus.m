% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/11 10:46:32 $
% $Revision: 1.1 $

function fr=plus(a,b)
% addition 
% einfachster Fall: Addiere eine konstante Zahl
% sonst: Addiere die beiden Frames

if isnumeric(b)
    a.values=a.values+b;
    fr=a;
    return
end

if isobject(a)
	a.values=a.values+b.values;
	fr=a;
	return
end