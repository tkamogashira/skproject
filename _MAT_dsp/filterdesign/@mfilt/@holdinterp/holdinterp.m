function Hm = holdinterp(L)
%HOLDINTERP FIR Hold Interpolator.
%   Hm = MFILT.HOLDINTERP(L) returns an FIR hold interpolator Hm with an
%   interpolation factor L. L must be an integer. If not specified,
%   it defaults to 2.
%
%   EXAMPLE: 
%      %Interpolation by a factor of 2 (used to convert from 22.05kHz
%      %to 44.1kHz)
%      L = 2;                               % Interpolation factor
%      Hm = mfilt.holdinterp(L);
%      Fs = 22.05e3;                        % Original sampling frequency: 22.05kHz
%      n = 0:5119;                          % 5120 samples, 0.232 second long signal
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 10240 samples, still 0.232 seconds
%      stem(n(1:22)/Fs,x(1:22),'filled')    % Plot original sampled at 22.05kHz 
%      hold on                              % Plot interpolated signal (44.1kHz) in red
%      stem(n(1:44)/(Fs*L),y(1:44),'r')
%      xlabel('Time (sec)');ylabel('Signal value')
%
%   See also MFILT/STRUCTURES.

%   Author: V. Pellissier
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(0,1,nargin,'struct'));

Hm = mfilt.holdinterp;
Hm.FilterStructure = 'FIR Hold Interpolator';

if nargin>0,
    Hm.InterpolationFactor = L;
end

% [EOF]
