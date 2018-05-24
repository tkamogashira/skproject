function Hm = firtdecim(M,num)
%FIRTDECIM Direct-Form Transposed FIR Polyphase Decimator.
%   Hm = MFILT.FIRTDECIM(M) returns an decimator object Hm based  on a
%   transposed FIR structure with an decimation factor of M. A low-pass
%   Nyquist filter of gain 1 and cutoff frequncy of Pi/M is designed by
%   default. This filter allows some aliasing in the transition band but
%   it's been chosen for its efficiency since it's first polyphase
%   component is a pure delay.
%
%   Hm = MFILT.FIRTDECIM(M,NUM) returns a direct-form transposed FIR
%   polyphase decimator Hm. 
%
%   M is the decimation factor. It must be an integer. If not specified, it
%   defaults to 2.
%
%   NUM is a vector containing the coefficients of the FIR lowpass filter
%   used for decimation. If omitted, a low-pass Nyquist filter of gain 1
%   and cutoff frequency of Pi/M is designed by default.
%
%   EXAMPLE: 
%      %Decimation by a factor of 2 (used to convert from 44.1kHz
%      %to 22.05kHz)
%      M = 2;                               % Decimation factor
%      Hm = mfilt.firtdecim(M);             % We use the default filter
%      Fs = 44.1e3;                         % Original sampling frequency: 44.1kHz
%      n = 0:10239;                         % 10240 samples, 0.232 second long signal
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 5120 samples, still 0.232 seconds
%      stem(n(1:44)/Fs,x(1:44))             % Plot original sampled at 44.1kHz 
%      hold on                              % Plot decimated signal (22.05kHz) in red
%      stem(n(1:22)/(Fs/M),y(13:34),'r','filled')
%      xlabel('Time (sec)');ylabel('Signal value')
%
%   See also MFILT/STRUCTURES.

%   Author: V. Pellissier
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(0,2,nargin,'struct'));

Hm = mfilt.firtdecim;

Hm.FilterStructure = 'Direct-Form Transposed FIR Polyphase Decimator';

if nargin>0
  Hm.DecimationFactor = M;
end

if nargin < 2,
	Hm.Numerator = defaultfilter(Hm,1,Hm.DecimationFactor);
elseif isa(num,'dfilt.singleton') && isfir(num),    
    [b,a] = tf(num);
    Hm.Numerator = b;
else
    num = num(:).';
	Hm.Numerator = num;
end


% [EOF]
