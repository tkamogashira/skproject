% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function doubles=cell2double(cell,name)
% usage: doubles=cell2double(cell,name)
% returns a array of doubles, if the cell is a string of numbers
% the cell must have the filds name

nr=length(cell);
doubles=zeros(nr,1);

for i=1:nr
    eval(sprintf('doubles(i)=cell{i}.%s;',name));
end
