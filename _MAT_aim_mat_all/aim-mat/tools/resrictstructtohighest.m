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


function res=resrictstructtohighest(str,topic,maxrange)


nr=length(str);

for i=1:nr
    sortcount(i)=eval(sprintf('str{%d}.%s',i,topic));
end

maxheight=max(sortcount);

count=1;
for i=1:nr
    if sortcount(i) > maxheight*(1-maxrange)
        res{count}=str{i};
    end
end



