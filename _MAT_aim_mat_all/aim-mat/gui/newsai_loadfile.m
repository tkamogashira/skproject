% procedure for 'aim-mat'
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


function [frm,options]=newsai_loadfile(name)
% load the nap and its options


load(name);

whodir=who;
for i=1:length(whodir)
    if ~strcmp(whodir(i),'name')
        eval(sprintf('classstruct=%s.data;',whodir{i}));
        eval(sprintf('options=%s.options;',whodir{i}));
        if strcmp(whodir(i),'strobestruct')
            frm=classstruct;
        else
            % construct the frame from whatever (sometimes the object is not recognised
            % as object due to the version ??)
            if isobject(classstruct)
                frm=classstruct;
            else
                nr=length(classstruct);
                if nr==1
                    frm=frame(classstruct);
                else
                    for i=1:nr
                        frm{i}=frame(classstruct{i});
                    end
                end
            end
        end         
    end
end



