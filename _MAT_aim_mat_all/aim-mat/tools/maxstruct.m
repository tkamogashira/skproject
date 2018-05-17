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


function [ret,womax]=maxstruct(str,topic,nr_second_dimension)
% gets back the structitem with the highest value in "topic"
% if topic is twodimensional, then "nr_second_dimension" gives the chosen
% number


if nargin < 3
    nr=size(str,2);
    for i=1:nr
        sortcount(i)=eval(sprintf('str{%d}.%s',i,topic));
    end
    [ismax,womax]=max(sortcount);
	ret=str{womax};
else
    nr=size(str,2);
    for i=1:nr
        sortcount(i)=eval(sprintf('str(%d).%s(%d)',i,topic,nr_second_dimension));
    end
    [ismax,womax]=max(sortcount);
	ret=str{womax};
end