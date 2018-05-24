function str = dspblkdly2(action,varargin)
% DSPBLKDLY2 Mask dynamic dialog function for integer delay block

% Copyright 1995-2011 The MathWorks, Inc.
if nargin==0
   action = 'dynamic';   % mask callback
end

switch action
case 'icon'
    delay_lit = varargin{1};
    delay_eval = varargin{2};
    
    if isempty(delay_eval)
        str = ['-(' delay_lit ')'];
    else
       	str = ['-' mat2str(delay_eval)];      
    end
   otherwise
      error(message('dsp:dspblkdly2:unhandledCase'));
end




% [EOF] dspblkdly2.m
