function [si,so] = dspblklsp2poly(action)
% DSPBLKPOLY2LSF Mask helper function for LSP to poly conversion block.

% Copyright 1995-2004 The MathWorks, Inc.

if nargin==0, action='dynamic'; end
blk = gcbh;
input = get_param(blk,'input');  % Value and Index|Value|Index|Running

switch action
case 'dynamic'
   % No action required
   
case 'icon'
   % Input port labels:
   si(1).port = 1;
   switch input
   case 'LSP in range (-1 1)'       
       si(1).txt = 'LSP';
   case 'LSF in range (0 pi)'
       si(1).txt = 'LSFr';
   otherwise 
       si(1).txt = 'LSFn';
   end
   
   
   % Output port labels:
   so(1).port = 1;
   so(1).txt = 'A';
       
end

% [EOF] dspblkpoly2lsp.m
