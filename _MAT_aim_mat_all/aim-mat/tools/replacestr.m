% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ret=replacestr(orginal,org,sub)
% usage: ret=replacestr(orginal,org,sub)
% replaces org with sub without any error checking

a=findstr(orginal,org);
while ~isempty(a)
    orginal(a)=sub;
    a=findstr(orginal,org);
end 

ret=orginal;
