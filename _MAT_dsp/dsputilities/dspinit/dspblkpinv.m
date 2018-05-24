function s = dspblkpinv
% DSPBLKPINV DSP System Toolbox Pseudo Inverse block helper function.

% Copyright 1995-2006 The MathWorks, Inc.

blk = gcbh;

wanterr = strcmp(get_param(blk,'wanterr'),'on');

% Setup port label structure:
switch(wanterr)
  case 0,
    % 1 input (A)
    % 1 outputs (A+)
   s.i1 = 1; s.i1s = 'A'; 
   s.o1 = 1; s.o1s = 'X';
   s.o2 = 1; s.o2s = '';
  case 1,
    % 1 input (A)
    % 1 outputs (A+,E)
   s.i1 = 1; s.i1s = 'A'; 
   s.o1 = 1; s.o1s = 'X';
   s.o2 = 2; s.o2s = 'E';
end
    
% [EOF] dspblkpinv.m
