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

function fr=normaliseto(fr,value)
% usage: 
% scale all values linear so that the sum of all activity is "value"

nr_ch=getnrchannels(fr);

values=getvalues(fr);
summe=sum(sum(values));

values=values.*value/summe;

fr=setvalues(fr,values);
