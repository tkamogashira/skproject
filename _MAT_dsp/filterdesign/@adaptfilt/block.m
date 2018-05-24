%BLOCK Generate a DSP System Toolbox block.
%   BLOCK(Hm) generates a DSP System Toolbox block equivalent to Hm.
%
%   BLOCK(Hm, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) generates a
%   DSP System Toolbox block using the options specified in the
%   parameter/value pairs. The available parameters are:
%
%   Destination:    <'Current'>, 'New'
%   Blockname:      'Filter' by default
%   OverwriteBlock: 'on', <'off'>
%   MapStates:      'on', <'off'>
%
%    EXAMPLES:
%    H = adaptfilt.lms;
% 
%    %#1 Default syntax:
%    block(H);
% 
%    %#2 Using parameter/value pairs:
%    block(H, 'Blockname', 'LMS');

% Copyright 1999-2010 The MathWorks, Inc.

% Help for the filter's BLOCK method.

% [EOF]
