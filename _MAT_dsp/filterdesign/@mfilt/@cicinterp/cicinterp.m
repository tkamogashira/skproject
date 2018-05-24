function Hm = cicinterp(varargin)
%CICINTERP Cascaded Integrator-Comb Interpolator.
%   Hm = MFILT.CICINTERP(R,M,N,IWL,OWL,WLPS) constructs a Cascaded 
%   Integrator-Comb (CIC) interpolation filter. This structure has a 
%   latency of N (number of sections).  The construction of this object 
%   requires the Fixed-Point Designer.
%   
%   Inputs:
%   R is the interpolation factor
%   M is the differential delay
%   N is the number of sections
%   IWL is the wordlength of the input signal
%   OWL is the wordlength of the output signal 
%   WLPS can be a scalar or vector (of length 2*N). WLPS defines the word 
%        lengths per section used during either the accumulation of the 
%        data in the integrator sections or the subtraction of the data 
%        performed by the comb section (using 'wrap' arithmetic). If WLPS 
%        is a scalar, that value is applied to each filter section. 
%
%   % EXAMPLE: Interpolation by a factor of 2 (used to convert from 22.05kHz
%   % to 44.1kHz)
%   R = 2;                    % Interpolation factor
%   Hm = mfilt.cicinterp(R);  % Use default NumberOfSections & DifferentialDelay
%   Fs = 22.05e3;             % Original sampling frequency: 22.05kHz
%   n = 0:5119;               % 5120 samples, 0.232 second long signal
%   x  = sin(2*pi*1e3/Fs*n);  % Original signal, sinusoid at 1kHz
% 
%   y_fi = filter(Hm,x); % 5120 samples, still 0.232 seconds
% 
%   % Scale the output to overlay plots
%   x = double(x); y = double(y_fi); y = y/max(abs(y));
%   stem(n(1:22)/Fs,x(1:22),'filled'); hold on; % Plot original sampled at 22.05kHz 
%   stem(n(1:44)/(Fs*R),y(4:47),'r');           % Plot interpolated signal (44.1kHz) in red
%   xlabel('Time (sec)');ylabel('Signal value');
%
%   See also MFILT/STRUCTURES.

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

if ~isfixptinstalled,
     error(message('dsp:mfilt:cicinterp:cicinterp:fixptTbxRq'));
end

Hm = mfilt.cicinterp;
set(Hm,'FilterStructure','Cascaded Integrator-Comb Interpolator');

set_arith(Hm, 'fixed');

if nargin > 0,
    set(Hm,'InterpolationFactor',varargin{1});
end

% Initialization utility.
cic_init(Hm,varargin{2:end});


% [EOF]
