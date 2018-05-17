% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function param=setstringvalue(param,text,strvalue,inbox)
%% sets the parameter value in the parameter "text" in the panel "inbox" to
%% the value "strvalue" no units or anything are used

if nargin<5
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.stringvalue=strvalue;
    if isfield(param.entries{nr},'handle') && ishandle(param.entries{nr}.handle{1}) % and set in the gui as well
        hand=param.entries{nr}.handle{1};
        set(hand,'String',param.entries{nr}.stringvalue);   % set the string as given
    end
    return
else
    error('setvalue::error, the entry does not exist');
end
