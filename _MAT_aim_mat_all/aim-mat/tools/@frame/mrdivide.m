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

function fr=mrdivide(fr,b)
% division ist einfach multiplikation mit 1/

if isnumeric(b)
    fr=fr*(1/b);
    return
end

error('fr::mrdivide: not implemented yet');