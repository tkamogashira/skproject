function varargout = dspblkperm2()
% DSPBLKPERM2 Variable Selector block helper function.

% Copyright 1995-2004 The MathWorks, Inc.

blk = gcbh;

[ELEMENTS, FILLVALUES] = deal(4, 8);
isfixed = strcmp(get_param(blk, 'IdxMode'), 'Fixed');

mv = get_param(blk, 'MaskVisibilities');
oldmv = mv;
if isfixed 
    mv{ELEMENTS} = 'on';
else
    mv{ELEMENTS} = 'off';
end
mv{FILLVALUES} = get_param(blk, 'FillMode');
if ~isequal(mv, oldmv)
    set_param(blk, 'MaskVisibilities', mv);
end

% [EOF] dspblkperm2.m
