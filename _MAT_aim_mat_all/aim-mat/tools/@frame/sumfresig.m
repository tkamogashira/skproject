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

function sig=sumfresig(fr)

number=max(size(fr));

if number==1
    val=fr.values;

    summe=sum(val');
    cfs=fr.centerfrequencies;
    max_fre=max(cfs);
    
    sig=signal(summe);
    sig=setsr(sig,1);
    sig=setxlabels(sig,cfs);
    sig=setunit_x(sig,'Frequency(kHz)');
    sig=setname(sig,'Sum of Frequencies');
else
        not implemented yet
end
