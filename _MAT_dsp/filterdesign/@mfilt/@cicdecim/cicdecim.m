function Hm = cicdecim(varargin)
%CICDECIM Cascaded Integrator-Comb Decimator.
%   Hm = MFILT.CICDECIM(R,M,N,IWL,OWL,WLPS)constructs a Cascaded 
%   Integrator-Comb (CIC) decimation filter object. This structure
%   has a latency of N (number of sections).  The construction of this 
%   object requires the Fixed-Point Designer.
%   
%   Inputs:
%   R is the decimation factor
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
%   % EXAMPLE: Decimation by a factor of 2 (used to convert from 44.1kHz
%   % to 22.05kHz)
%   R = 2;                       % Decimation factor
%   Hm = mfilt.cicdecim(R);      % Use default NumberOfSections & DifferentialDelay
%   Fs = 44.1e3;                 % Original sampling frequency: 44.1kHz
%   n = 0:10239;                 % 10240 samples, 0.232 second long signal
%   x  = sin(2*pi*1e3/Fs*n);     % Original signal, sinusoid at 1kHz
% 
%   y_fi = filter(Hm,x); % 5120 samples, still 0.232 seconds
% 
%   % Scale output to overlay plots
%   x = double(x); y = double(y_fi); y = y/max(abs(y));
%   stem(n(1:44)/Fs,x(2:45)); hold on;           % Plot original sampled at 44.1kHz
%   stem(n(1:22)/(Fs/R),y(3:24),'r','filled');   % Plot decimated signal (22.05kHz) in red
%   xlabel('Time (sec)');ylabel('Signal value');
%
%   See also MFILT/STRUCTURES.

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

if ~isfixptinstalled,
     error(message('dsp:mfilt:cicdecim:cicdecim:fixptTbxRq'));
end

Hm = mfilt.cicdecim;
set(Hm,'FilterStructure','Cascaded Integrator-Comb Decimator');

set_arith(Hm, 'fixed');

if nargin > 0,
    set(Hm,'DecimationFactor',varargin{1});
end

% Initialization utility used in both CIC classes.
cic_init(Hm,varargin{2:end});


% [EOF]
