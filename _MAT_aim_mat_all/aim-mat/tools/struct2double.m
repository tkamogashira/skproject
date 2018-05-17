% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ret=struct2double(str,field,mmm)
% returns a field of the values in str.fild
% like: ret=str(1:12).value

nr=length(str);
if nargin < 3
    % ret=zeros(nr,1);
    for i=1:nr
        eval(sprintf('dim=length(str(1).%s);',field));
        if dim==1
            eval(sprintf('ret(%d)=str(%d).%s;',i,i,field));
        else
            eval(sprintf('ret(%d,:)=str(%d).%s;',i,i,field));
        end
    end
else
    for i=1:nr
        eval(sprintf('ret(%d,:)=str(%d).%s(%d);',i,i,field,mmm));
    end
end