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
% $Date: 2003/03/13 14:48:22 $
% $Revision: 1.6 $

function nap=logcompress(nap,options)

%if nargin <2
%    options.dynamic_range=50;
%end

nap=halfwayrectify(nap);
vals=getvalues(nap);

%gtfb output values are: 0< gt_vals <1
%therefore we will scale for 16bit values
%operationally only 15 bits are used as we
%half wave rectify
vals=vals.*2.^15;

%avoid log problems by making everything > 1
vals(find(vals<1))=1;
vals=20.*log10(vals);


nap=setvalues(nap,vals);

