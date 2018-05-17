% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function param=sethandle(param,text,hand,inbox,handle_nr)
% sets the handle of this item. handles_nr is usually 1 but can be 2 in
% cases when more then one object is on the screen (float with unit,
% filename...)

cont=param.entries;
nrent=length(cont);

if nargin<5
    handle_nr=1;
end

if nargin<4
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.handle{handle_nr}=hand;
    return
else
    val='sethandle: error, the entry does not exist';
end
