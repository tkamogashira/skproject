function FVToolOpen = dspIsFVToolOpen(block)
% FVToolOpen = dspIsFVToolOpen(blockName)
%
% Returns true if the block has an associated linked FVTool figure window
% open.

% Copyright 2005 The MathWorks, Inc.

ud = get_param(block, 'UserData');

% Get the Figure & FVTool handles
if isfield(ud,'fvtool') && ~isempty(ud.fvtool) && ...
        isgraphics(ud.fvtool) && isappdata(ud.fvtool,'FVToolObjectHandle')
    FVToolOpen = true;
else
    FVToolOpen = false;
end
