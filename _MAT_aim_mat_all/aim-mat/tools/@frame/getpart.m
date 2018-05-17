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

function fr=getpart(frorg,t1,t2)

tempsig=getsinglechannel(frorg,1);

bin1=time2bin(tempsig,t1)+1;
bin2=time2bin(tempsig,t2);

old_data=getvalues(frorg);
new_data=old_data(:,bin1:bin2);

fr=frame(frorg);
fr=setvalues(fr,new_data);
fr=setstarttime(fr,t1);






