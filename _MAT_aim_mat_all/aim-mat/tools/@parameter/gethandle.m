% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function hand=gethandle(param,text,panel,handnr)
% set handle of one line. A line can have more then one handle, therefore
% nr can be bigger then one

if nargin<4
    handnr=1;
end

if nargin<3
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);

if nr>0
    if ~isfield(param.entries{nr},'handle')
        hand=0;
%         disp('error: handle does not exist');
        return
    end
    if length(param.entries{nr}.handle)>=handnr
        hand=param.entries{nr}.handle{handnr};
        if length(hand)>1
            hand=hand(handnr);
        end
    else
        hand=[];
    end
else
    hand=0;
    disp('error: handle does not exist');
end
