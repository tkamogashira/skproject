function varargout = dspblkg711(action, varargin)
%DSPBLKG711 DSP System Toolbox G.711 block

% Copyright 2003-2011 The MathWorks, Inc.

% Icon drawing and port labels
  
blk = gcbh;
  
switch action
 case 'icon'
  mode = varargin{1};
  [iS, iL, oL] = LocIcon(mode);
  varargout = {iS, iL, oL};
 case 'enables'
  LocEnables(blk);
 otherwise
  error(message('dsp:dspblkg711:unhandledCase'));
end

%
% Return the strings needed for the icon
%
function [iconStr, inLabel, outLabel] = LocIcon(mode)
iconStr  = 'G.711';
switch (mode)
 case 1
  inLabel  = 'PCM';
  outLabel = 'A';
 case 2
  inLabel  = 'PCM';
  outLabel = 'mu';
 case 3
  inLabel  = 'A';
  outLabel = 'PCM';
 case 4
  inLabel  = 'mu';
  outLabel = 'PCM';
 case 5
  inLabel  = 'A';
  outLabel = 'mu';
 case 6
  inLabel  = 'mu';
  outLabel = 'A';
 otherwise
  iconStr  = '';
  inLabel  = '';
  outLabel = '';
end

%
% Function that is called during MaskDialogCallback to 
% set the appropriate dialog enables and disables.
%
function LocEnables(blkH)
mode = get_param(blkH, 'mode');

if strcmp(mode, 'Encode PCM to A-law') | ...
  strcmp(mode, 'Encode PCM to mu-law')
  set_param(blkH, 'MaskEnables', {'on', 'on'});
  set_param(blkH, 'MaskVisibilities', {'on', 'on'});
else
  set_param(blkH, 'MaskEnables', {'on', 'off'});
  set_param(blkH, 'MaskVisibilities', {'on', 'off'});
end
  

% [EOF] dspblkg711.m
