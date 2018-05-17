% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function linmeasure=log2lin(value,scaleinfo)

% wandelt einen Wert entsprechend den Angaben in scaleinfo wieder 
% in den ursprünglichen linearen Wert zurück

from=scaleinfo.from;
to=scaleinfo.to;
steps=scaleinfo.steps;

a1=log(from);
a2=log(to);
st=(a2-a1)/(steps-1);

linmeasure=log(value/from)/st+1;
