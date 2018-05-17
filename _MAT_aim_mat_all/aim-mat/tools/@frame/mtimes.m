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
% $Date: 2003/01/17 16:57:46 $
% $Revision: 1.3 $

function fr=mtimes(fr,val)
% multiplikation mit *
% einfachster Fall: Multipliziere mit konstanter Zahl

if isnumeric(val)
    if length(val)==1
        fr.values=fr.values*val;
    end
end

if isobject(val)
    error('not implemented yet!');
end
