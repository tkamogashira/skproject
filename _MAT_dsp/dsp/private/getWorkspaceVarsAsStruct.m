function s = getWorkspaceVarsAsStruct(blk)
% Get mask workspace variables:

% Copyright 1995-2012 The MathWorks, Inc.

% Dive into the BaseMask - the block may have more than one mask
aMaskObject = Simulink.Mask.get(blk);
while (~isempty(aMaskObject) && ~isempty(aMaskObject.BaseMask))
    aMaskObject = aMaskObject.BaseMask;
end

ss = aMaskObject.getWorkspaceVariables();
if isempty(ss),
    s=struct([]);
    warning(message('dsp:getWorkspaceVarsAsStruct:no_ws_vars'));
    return
end

% Only the first "numdlg" variables are from dialog;
% others are created in the mask init fcn itself.
dlg = {aMaskObject.Parameters(:).Name};
ss = ss((ismember({ss.Name}, dlg) == 1));

% Create a structure with:
%   field names  = variable names
%   field values = variable values
s = cell2struct({ss.Value}',{ss.Name}',1);

% [EOF] $File: $
