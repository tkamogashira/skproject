function Y = CreateFigCallback(figh, ev);
% CreateFigCallback - generic figure create function for EARLY.
%   CreateFigCallback, which is called whenever a figure is opened, does 
%   the following:
%      * append a PasteLine menu item in the Edit menu
%
%   See also LineCopeMenu.

% get handle
shh=get(0,'showhiddenhandles');
set(0,'showhiddenhandles','on');
hmenu = findobj(figh, 'type', 'uimenu', 'label', '&Edit');
set(0,'showhiddenhandles',shh);
if ~isempty(hmenu),
    uimenu(hmenu,'label','Paste Line', 'separator', 'on', 'callback', @local_pasteline);
end


%=========================
function local_pasteline(src,ev);
% paste line from "line clip board"
L = linecopymenu('paste'); % struct containing all props of pasted line
if isempty(L),return; end
L = rmfield(L,{'Annotation' 'BeingDeleted' 'Children' 'Parent' 'Type' ...
    'UIContextMenu' 'XDataMode' 'XDataSource' 'YDataSource' 'ZDataSource' });
try,
    line(L);
catch,
    warning(lasterr)
end



