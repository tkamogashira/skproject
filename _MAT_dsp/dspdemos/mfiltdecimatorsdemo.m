%% FIR Decimation
% This example shows how to decrease the sampling rate of a signal using
% FIR decimators from the DSP System Toolbox(TM). 

% Copyright 1999-2012 The MathWorks, Inc. 

%% Creating FIR Decimators
% The DSP System Toolbox supports different structures to perform
% decimation including different FIR based structures and CICs. Given an
% decimation factor M, a common design of an FIR decimation filter is a
% Nyquist filter with a cutoff frequency of pi/M. See the FIRHALFBAND,
% FIRNYQUIST, FIREQINT and INTFILT functions as well as
% FDESIGN.DECIMATOR and FDESIGN.NYQUIST for more on the design of
% decimation filters.
M  = 3; % Decimation factor
Hf = fdesign.decimator(M,'Nyquist',M);
Hd = design(Hf,'SystemObject',true); % Polyphase FIR Decimator

%%
% A more efficient implementation is the transposed FIR polyphase
% structure. This structure allows for sharing of the delays and
% multipliers
Hd.Structure = 'Direct form transposed';

%%
% To decimate by a fractional factor, you can use a Direct-Form FIR
% Polyphase Sample-Rate Converter. This structure uses L polyphase
% subfilters.
L   = 2; % Interpolation factor
Hf  = fdesign.rsrc(L,M,'Nyquist',max(L,M));
Hd2 = design(Hf,'SystemObject',true); % Polyphase FIR Fractional Decimator

%% Filtering with FIR Decimators
% The input signal x[n] is a 1 kHz sinusoid sampled at 44.1 kHz.
N = 159;
Fs = 44.1e3;           
n = (0:N-1)';                            
x = sin(2*pi*n*1e3/Fs); 

%%
% Filter with a Direct-Form FIR Polyphase Decimator.
y = step(Hd,x);

%%
% The length of the transient response of the decimator is equal to half
% the order of a polyphase subfilter. This is also the group-delay of the
% filter.
delay = mean(grpdelay(Hd)); % Constant group delay equal to its mean
tx = delay+(1:length(x));
ty = 1:M:M*length(y);

%%
% Display the output of the Direct-Form FIR Polyphase Decimator and overlay
% a shifted version of the original signal.
stem(tx,x,'k');hold on;stem(ty,y,'filled');
axis([0 90 -Inf Inf])
legend('Original signal','Decimated signal')
xlabel('Samples'); ylabel('Amplitude');

%% Frequency-Domain Analysis of the Interpolated Signal
% We compute the power spectral densities of both input and decimated
% signal.

% Create an audio file reader and point to an audio file with sound sampled
% at 48 kHz
Ha = dsp.AudioFileReader('audio48kHz.wav');

% Create a spectrum analyzer to view the spectrum of the input and
% decimated audio. 
Hs = dsp.SpectrumAnalyzer('SampleRate',48e3,'ShowLegend',true,...
  'SpectralAverages',10);

% Design an decimate-by-2 filter to decimate the signal from 48 kHz
% to 24 kHz
M  = 2;
Hf = fdesign.decimator(M,'Halfband');
Hd = design(Hf,'SystemObject',true);

%%
% The output will be upsampled independently to 48 kHz by inserting a zero
% between every sample in order to plot the input and output spectrum
% simultaneously. To maintain the same power level, the upsampled signal is
% multiplied by the upsampling factor.
while ~isDone(Ha)
    x  = step(Ha);        % Original 48 kHz audio
    y  = step(Hd,x);      % Decimated 24 kHz audio 
    yu = M*upsample(y,M); % Insert a zero every other sample to compare
    step(Hs,[x,yu]);
end

% Release Audio File Reader
release(Ha);

%%
% As expected, the decimated signal has spectral replicas centered at
% multiples of the low sampling frequency (24 kHz)

displayEndOfDemoMessage(mfilename)
