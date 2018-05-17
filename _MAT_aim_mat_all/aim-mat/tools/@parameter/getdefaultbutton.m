% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function param=getdefaultbutton(param)
% returns the parameter that was set as the default button

ents=param.entries;

for i=1:length(ents)
    if strcmp(ents{i}.type,'button')
       if  ents{i}.isdefaultbutton==1
           param=ents{i};
           return
       end
    end
end

param=[];