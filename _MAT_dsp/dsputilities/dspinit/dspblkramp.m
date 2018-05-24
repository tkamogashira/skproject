function dspblkramp()
% DSPBLKRAMP is the mask function for the DSP System Toolbox 
% Constant Ramp block.

% Copyright 1995-2010 The MathWorks, Inc.

% Make 'Dimension' parameter visible if 'Ramp length'
% parameter is set to 'Elements in specified dimension'
blkh = gcbh;
vis  = get_param(blkh,'maskvisibilities');

% Main dialog tab parameter order: L, dim, Slope, Offset, ...
oldDimVis = vis{2};

if strcmpi(get_param(blkh,'L'),'Elements in specified dimension')
    vis{2} = 'on';
else % Turn off dimension if Ramp Length is Rows or Columns
    vis{2} = 'off';
end

% update visibility if needed
if (~isequal(oldDimVis, vis{2}))
    obj = get_param(blkh,'object');
    obj.MaskVisibilities = vis;
end

% [EOF]
