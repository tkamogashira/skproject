function Hm = fftfirinterp(L,num,BL)
%FFTFIRINTERP Overlap-Add FIR Polyphase Interpolator.
%   Hd = MFILT.FFTFIRINTERP(L,NUM,BL) constructs an overlap-add FIR
%   polyphase interpolator.
%
%   L is the interpolation factor. It must be an integer. If not specified,
%   it defaults to 2.
%
%   NUM is a vector containing the coefficients of the FIR lowpass filter
%   used for interpolation. If omitted, a lowpass Nyquist filter of gain L
%   and cutoff frequency of Pi/L is used by default.
%
%   BL is the length of each block of input data used in the filtering. It
%   must be an integer. If not specified, it defaults to 100.
%
%   The number of FFT points is given by BL+ceil(length(NUM)/L)-1. It may be
%   advantageous to choose BL such that the number of FFT points is a power
%   of two.
%
%   EXAMPLE: 
%     %Interpolation by a factor of 8 (notice the removal of spectral replicas)
%     L = 8;                                % Interpolation factor
%     Hm = mfilt.fftfirinterp(L);           % We use the default filter
%     N = 8192;                             % Number of points
%     Hm.BlockLength = N;                   % Set block length to number of points
%     Fs = 44.1e3;                          % Original sampling frequency: 44.1kHz
%     n = 0:N-1;                            % 0.1858 secs of data
%     x = sin(2*pi*n*22e3/Fs);              % Original signal, sinusoid at 22kHz
%     y = filter(Hm,x);                     % Interpolated sinusoid
%     xu = L*upsample(x,8);                 % Upsample to compare (spectrum doesn't change)
%     [Px,f]=periodogram(xu,[],65536,L*Fs); % Power spectrum of original
%     [Py,f]=periodogram(y,[],65536,L*Fs);  % Power spectrum of interpolated
%     plot(f,10*log10(([Fs*Px,L*Fs*Py])))
%     legend('22 kHz sinusoid sampled at 44.1 kHz',...
%     '22 kHz sinusoid sampled at 352.8 kHz')
%     xlabel('Frequency (Hz)'); ylabel('Power spectrum');
%
%   See also MFILT/STRUCTURES.
  
%   Author: R. Losada
%   Copyright 1999-2008 The MathWorks, Inc.

Hm = mfilt.fftfirinterp;

Hm.FilterStructure = 'Overlap-Add FIR Polyphase Interpolator';

if nargin>0
  Hm.InterpolationFactor = L;
end

if nargin < 2,
    Hm.Numerator = defaultfilter(Hm,Hm.InterpolationFactor,1);
elseif isa(num,'dfilt.singleton') && isfir(num),    
    [b,a] = tf(num);
    Hm.Numerator = b;
else
    num = num(:).';
	Hm.Numerator = num;
end

if nargin < 3,
    % Set a default blocklength
    % Don't use factoryValue so overload set runs
    BL = 100;
end

Hm.BlockLength = BL;
