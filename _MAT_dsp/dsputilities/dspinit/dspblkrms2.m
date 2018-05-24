function [s,x] = dspblkrms2
% DSPBLKRMS2 DSP System Toolbox RMS block helper function.

% Copyright 1995-2005 The MathWorks, Inc.

blk = gcbh;
isRunning = strcmp(get_param(blk,'run'),'on');

% Setup port label structure:
if ~isRunning,
  % 1 input (in)
  % 1 output
  s.i1 = 1; s.i1s = '';
  s.i2 = 1; s.i2s = '';  %In

  x = 'RMS';

else
  % Running
  % 2 inputs (in, rst)
  % 1 output (val)
  isRst = ~strcmp(get_param(blk,'reset_popup'),'None');
  if isRunning && isRst
      s.i1 = 1; s.i1s = 'In';
      s.i2 = 2; s.i2s = 'Rst';
  else
      s.i1 = 1; s.i1s = '';
      s.i2 = 1; s.i2s = '';  % No need to annotate one input
  end

  x = 'Running\nRMS';
end
