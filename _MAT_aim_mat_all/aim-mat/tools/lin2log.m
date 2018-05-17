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


function logmeasure=lin2log(value,scaleinfo)
% usage: function logmeasure=lin2log(value,scaleinfo)
% wandelt einen Wert entsprechend den Angaben in scaleinfo 
% von einem linearen in einen logarithmischen Wert um
% scaleinfo.from;
% scaleinfo.to;
% scaleinfo.steps;
% 


from=scaleinfo.from;
to=scaleinfo.to;
steps=scaleinfo.steps;


if steps==1
    logmeasure=(from+to)/2;
    logmeasure=from;
    return
end

a1=log(from);
a2=log(to);
st=(a2-a1)/(steps-1);

res=st*value;
res=exp(res);

logmeasure=res*from;

