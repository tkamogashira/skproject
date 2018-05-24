%% FIR Interpolation
% This example shows how to increase the sampling rate of a signal using
% FIR interpolators from the DSP System Toolbox(TM). 

% Copyright 1999-2012 The MathWorks, Inc.

%% Creating FIR Interpolators
% The DSP System Toolbox supports different structures to perform
% interpolation including FIR-based structures and CICs. Given an
% interpolation factor L, a common design of an FIR interpolation filter is
% a Nyquist filter with a cutoff frequency of pi/L and a gain of L. This
% type of filter leaves the original samples unchanged and interpolates L-1
% samples between the original samples. See the FIRHALFBAND, FIRNYQUIST,
% FIREQINT and INTFILT functions as well as FDESIGN.INTERPOLATOR and
% FDESIGN.NYQUIST for more on the design of interpolation filters.
L  = 3; % Interpolation factor
Hf = fdesign.interpolator(L,'Nyquist',L);
Hi = design(Hf,'SystemObject',true); % Polyphase FIR Interpolator

%%
% To interpolate by a fractional factor, you can use a Direct-Form FIR
% Polyphase Sample-Rate Converter. This structure uses L polyphase
% subfilters.
M   = 2; % Decimation factor
Hf  = fdesign.rsrc(L,M,'Nyquist',max(L,M));
Hd2 = design(Hf,'SystemObject',true); % Polyphase FIR Fractional Decimator


%% Analyzing FIR Interpolators
% The default interpolation filter has linear phase. The info analysis in
% the Filter Visualization Tool (FVTool) confirms that.
hfvt = fvtool(Hi, 'Analysis', 'info');
set(hfvt, 'Color', [1 1 1])

%%
% Notice that even though the interpolation filter is symmetric and thus
% has linear phase, the polyphase components are not necessarily symmetric
% and thus will not necessarily have exact linear phase. However, for each
% nonsymmetric polyphase filter, there is a mirror image polyphase filter
% which will have the exact same magnitude response with a mirror image
% group-delay that will compensate any phase distortion.
set(hfvt, 'PolyphaseView','on', 'Analysis', 'grpdelay','Legend','on')

%% Filtering with FIR Interpolators
% The input signal x[n] is a 7 kHz sinusoid sampled at 44.1 kHz.
N  = 30;
Fs = 44.1e3;           
n  = (0:N-1).';                            
x  = sin(2*pi*n*7e3/Fs); 

% Filter with a Direct-Form FIR Polyphase Interpolator.
y1 = step(Hi,x);

%% Time-Domain Analysis of the Interpolated Signal
% The group-delay of the filter, in terms of input samples is half of the
% filter length minus one divided by the interpolation factor
delay = (length(Hi.Numerator)-1)/(2*L); 
t = delay*L+(0:L:L*length(x)-L); 
t1 = 0:length(y1)-1;

%%
% Display the output of the Direct-Form FIR Polyphase Interpolator and
% overlay the original signal (reference).
stem(t,x,'filled','k');hold on;stem(t1,y1);
axis([0 90 -Inf Inf])
legend('Original signal','Interpolated Signal',2)
xlabel('Samples'); ylabel('Amplitude');
set(gcf, 'Color', [1 1 1])

%% Frequency-Domain Analysis of the Interpolated Signal
% We compute the power spectral densities of both input and interpolated
% signal.

% Create an audio file reader and point to an audio file with sound sampled
% at 48 kHz
Ha = dsp.AudioFileReader('audio48kHz.wav');

% Create a spectrum analyzer to view the spectrum of the input and
% interpolated audio. 
Hs = dsp.SpectrumAnalyzer('SampleRate',96e3,'ShowLegend',true,...
  'SpectralAverages',10);

% Design an interpolate-by-2 filter to interpolate the signal from 48 kHz
% to 96 kHz
L  = 2;
Hf = fdesign.interpolator(L,'Halfband');
Hi = design(Hf,'SystemObject',true);

%%
% The input is upsampled independently to 96 kHz by inserting a zero
% between every sample in order to plot the input and output spectrum
% simultaneously. To maintain the same power level, the upsampled signal is
% multiplied by the upsampling factor.
while ~isDone(Ha)
    x  = step(Ha);        % Original 48 kHz audio
    xu = L*upsample(x,L); % Insert a zero every other sample to compare
    y  = step(Hi,x);      % Interpolated 96 kHz audio (input is x, not xu)
    step(Hs,[xu,y]);
end

% Release Audio File Reader
release(Ha);

%%
% As expected, the interpolation filter removes spectral replicas from the
% original signal.

displayEndOfDemoMessage(mfilename)
