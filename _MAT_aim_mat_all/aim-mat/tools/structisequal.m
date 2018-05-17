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


function ret=structisequal(str1,str2)

s1=struct2stringarray(str1,'test');
s2=struct2stringarray(str2,'test');

strings1=sort(s1);
strings2=sort(s2);

nr1=length(strings1);
nr2=length(strings2);
if nr1~=nr2
    ret=0;
    return
end

for i=1:nr1
    s1=strings1(i);s1=s1{1};
    s2=strings2(i);s2=s2{1};
    if length(s1)~=length(s2)
        ret=0;
        return
    end
    if ~isempty(find(s1~=s2))
        ret=0;
        return
    end
end
ret=1;