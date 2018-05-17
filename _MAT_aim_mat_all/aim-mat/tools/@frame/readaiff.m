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

function nap=readaiff(fr,aifffilename,spffilename)

content_spfmodel=loadtextfile(spffilename);
cf=DSAMGetCFs(content_spfmodel);

naps=SBReadAiff(aifffilename,0);    % returns all info in a struct

nap=naps(1);
nap=setcf(nap,cf);




