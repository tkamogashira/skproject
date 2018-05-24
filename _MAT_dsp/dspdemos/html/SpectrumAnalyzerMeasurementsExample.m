%% Spectrum Analyzer Measurements
% This example shows how to perform measurements using the Spectrum
% Analyzer block.  The example contains a typical set up to perform
% harmonic distortion measurements (THD, SNR, SINAD, SFDR) third-order
% intermodulation distortion measurements (TOI), adjacent channel power
% ratio measurements (ACPR), complementary cumulative distribution function
% (CCDF), and peak to average power ratio (PAPR).  The example also shows
% how to view time-varying spectra by use of a spectrogram and automatic
% peak detection.

%%
% Several measurements and their corresponding setup are contained in the
% example model.
%
HelperSpectrumAnalyzerMeasurements('openModel');

%% Exploring the Example
% The model consists of five simple models of an amplifier, each of which
% is set up to perform specific measurements.
%
% Open an amplifier model by double-clicking on an Amplifier block.
% The first amplifier model is shown below:

HelperSpectrumAnalyzerMeasurements('openAmplifier');

%%
% You will see the input is first combined with a noise source consisting
% of Gaussian noise and then run through a high-order polynomial to model
% non-linear distortion.
%
% You can modify the amount of additive noise on the input by clicking on
% the Noise Source and modifying the variance of the Gaussian distribution.
% This will affect the noise of the amplifier.
%
% You can modify the parameters of the amplifier by changing the polynomial
% coefficients.  The coefficients are arranged from highest-to-lowest
% order.  If you edit the last coefficient you change the DC voltage offset
% of the amplifier, if you change the next-to-last coefficient, you change
% the voltage gain of the amplifier, if you change other coefficients you
% can change the higher order harmonics of the amplifier.

%% Harmonic Distortion
% You can measure harmonic distortion by stimulating the amplifier with a
% sinusoidal input and viewing the harmonics in a spectrum analyzer.  The
% harmonic distortion measurements can be invoked from the Measurements
% option in the Tools menu, or by clicking is corresponding icon in the
% toolbar (shown depressed in the figure, below).

HelperSpectrumAnalyzerMeasurements('runModel');
HelperSpectrumAnalyzerMeasurements('showHarmonicDistortion');

%%
% If you view the results in the distortion measurement panel you will see
% the values of the fundamental and harmonics as well as their SNR, SINAD,
% THD and SFDR values, which are referenced with respect to the fundamental
% output power.

%% Third Order Intermodulation Distortion
% Amplifiers typically have significant odd-order harmonics.  If you
% stimulate the amplifier with two closely-spaced sinusoids of equal
% amplitude, you can produce intermodulation products at the output.
% Typically the distortion products decay away from the fundamental tones,
% the largest of which correspond to the third-order sum and difference
% frequencies of the input waveform.  You can measure output third-order
% intermodulation distortion (TOI) by stimulating the amplifier with two
% sinusoids spaced a close distance apart.   You can select intermodulation
% distortion measurements from the drop-down menu in the distortion
% measurement panel.

HelperSpectrumAnalyzerMeasurements('showIntermodulationDistortion');

%%
% If you view the results in the distortion measurement panel you will see
% the intermodulation products highlighted and the output TOI displayed.
% If you adjust the polynomial coefficients in the amplifier, you can
% adjust the harmonics shown in the signal. 

%% ACPR
% If you stimulate an amplifier that is broadcasting a communications
% channel, you may see spectral growth leaking into the bandwidth of
% neighboring channels due to intermodulation distortion.  You can measure
% how much power leaks into these adjacent channels by measuring the
% adjacent channel power ratio (ACPR).  You can see the measurements both
% before and after the amplifier by toggling the measurement input in the
% Trace Selection Dialog.  ACPR measurements can be selected from the
% drop-down menu in the Channel Measurements dialog.  This dialog can be
% invoked from the Measurements option in the Tools menu, or by
% clicking is corresponding icon in the toolbar (shown depressed in the
% figure, below).

HelperSpectrumAnalyzerMeasurements('showACPR');

%%
% If you adjust the polynomial coefficients in the amplifier, you can
% observe different amounts of spreading of the central power due to
% intermodulation distortion by observing the ACPR readings at the
% specified offset frequencies.

%% CCDF
% You can qualitatively verify how much dynamic range an output signal
% occupies by viewing complementary cumulative distribution function
% (CCDF).  The CCDF dialog can be invoked from the Measurements option in
% the Tools menu, or by clicking is corresponding icon in the toolbar
% (shown depressed in the figure, below).

HelperSpectrumAnalyzerMeasurements('showCCDF');

%%
% In the above example you can see about a 0.5 dB compression between the
% input source (blue trace) and the output of Amplifier4 (yellow trace).
% The peak-to-average power ratio (PAPR) for the input channel is 3.3 dB
% whereas the PAPR for the output channel is 2.8 dB. This loss of dynamic
% range suggests that there is too much input power applied to the
% amplifier.

%% Spectrogram
% You can view time-varying spectral information by using the Spectrogram
% Mode of the spectrum analyzer.  If you stimulate the amplifier with a
% chirp waveform you can observe how the harmonics behave as time
% progresses.  This spectrogram view can be selecting Spectrogram from
% the "Type" dropdown menu in the Spectrum Settings dialog, which invoked
% from the Spectrum Settings dialog found in the View menu (not shown).

HelperSpectrumAnalyzerMeasurements('showSpectrogram');

%%
% You can use cursors to make measurements of the period of the chirp and
% to confirm that the other spectral components are indeed harmonically
% related.  The Cursor Measurements dialog can be invoked from the
% Measurements option in the Tools menu, or by clicking is
% corresponding icon in the toolbar (shown depressed in the figure, above).

%% Peak Finder
% You can track time-varying spectral components by using the Peak Finder
% measurement dialog.  You can show and optionally label up to 100 peaks.
% The Peak Finder dialog can be invoked from the Measurements option in
% the Tools menu, or by clicking is corresponding icon in the toolbar
% (shown depressed in the figure, above).
HelperSpectrumAnalyzerMeasurements('showPeakFinder');

%%
HelperSpectrumAnalyzerMeasurements('closeModel');

%% References
% * IEEE Std. 1057-1994 IEEE Standard for Digitizing Waveform Recorders
% * Allan W. Scott, Rex Frobenius, RF Measurements for Cellular Phones and
%   Wireless Data Systems, John Wiley & Sons, Inc. 2008

%%
% Copyright 2013 The MathWorks, Inc.

