function varargout = dspblkcnvrt1d2d
% DSPBLKCNVRT1D2D Mask dynamic dialog function for
% Convert 1-D to 2-D block in DSPUTILS library


% Copyright 1995-2004 The MathWorks, Inc.
blk = gcb;
frameStatusBlk = [blk '/Frame Conversion'];

% Determine "Frame-based output" checkbox setting
desiredFrame  = get_param(blk,'frameBasedOut');

% Only update if a change was really made:
if isequal(desiredFrame,'off')
        set_param(frameStatusBlk,'OutFrame','Sample based');
elseif isequal(desiredFrame,'on')
        set_param(frameStatusBlk,'OutFrame','Frame based');
end

% [EOF] dspblkcnvrt1d2d.m
