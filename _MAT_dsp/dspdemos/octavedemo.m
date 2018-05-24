%% Octave-Band and Fractional Octave-Band Filters
% This example shows how to design octave-band and fractional octave-band
% filters. Octave-band and fractional-octave-band filters are commonly used
% in acoustics, for example, in noise control to perform spectral analysis.
% Acousticians prefer to work with octave or fractional (often 1/3) octave
% filter banks because it gives them a more meaningful measure of the noise
% power in different frequency bands.

% Copyright 2007-2013 The MathWorks, Inc.

%% Design of a Full Octave-Band and a 1/3-Octave-Band Filter Banks
% An octave is the interval between two frequencies having a ratio of 2:1.
% An octave-band or fractional-octave-band filter is a bandpass filter
% determined by its center frequency and its order. The magnitude
% attenuation limits are defined in the ANSI(R) S1.11-2004 standard for
% three classes of filters: class 0, class 1 and class 2. Class 0 allow
% only +/-.15 dB of ripples in the passband while class 1 filters allow
% +/-.3 dB and class 2 filters allow +/-.5 dB. Levels of stopband
% attenuation vary from 60 to 75dB depending on the class of the filter.
%%
% Design a full octave-band filter bank:
BandsPerOctave = 1;  
N = 6;           % Filter Order
F0 = 1000;       % Center Frequency (Hz)
Fs = 48000;      % Sampling Frequency (Hz)
f = fdesign.octave(BandsPerOctave,'Class 1','N,F0',N,F0,Fs);
%%
% Get all the valid center frequencies in the audio range to design the
% filter bank:
F0 = validfrequencies(f);
Nfc = length(F0);
for i=1:Nfc,
    f.F0 = F0(i);
    Hd(i) = design(f,'butter');
end
%%
% Now design a 1/3-octave-band filter bank. Increase the order of each
% filter to 8:
f.BandsPerOctave = 3;
f.FilterOrder = 8;
F0 = validfrequencies(f);
Nfc = length(F0);
for i=1:Nfc,
    f.F0 = F0(i);
    Hd3(i) = design(f,'butter');
end
%%
% Visualize the magnitude response of the two filter banks. The 1/3-octave
% filter bank will provide a finer spectral analysis but at an increased
% cost since it requires 30 filters versus 10 for the full octave filter
% bank to cover the audio range [20 20000 Hz].
hfvt = fvtool(Hd,'FrequencyScale','log','color','white');
axis([0.01 24 -90 5])
title('Octave-Band Filter Bank')
hfvt = fvtool(Hd3,'FrequencyScale','log','color','white');
axis([0.01 24 -90 5])
title('1/3-Octave-Band Filter Bank')

%% Spectral Analysis of White Noise
% The human ear interprets loudness of sound on a scale much closer to a
% logarithmic scale than a linear one but a DFT-based frequency analysis
% leads to linear frequency scale. Compute the (DFT-based) power spectrum
% of a white noise signal using a spectrum analyzer:
Nx = 100000;
SA = dsp.SpectrumAnalyzer('SpectralAverages',50,'SampleRate',Fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log',...
    'YLimits', [-80 20]);
tic,
while toc < 15
    % Run for 15 seconds
    xw = randn(Nx,1);
    step(SA,xw);
end
%%
% Now filter the white noise signal with the 1/3-octave filter bank and
% compute the average power at the output of each filter. While the power
% spectrum of a white noise signal is flat, the high frequencies are
% perceived louder. The 1/3-octave spectrum paints a picture that is closer
% to the human ear perception. It shows a spectrum where the power level
% rise 3dB per octave because each band (i.e. filter) has twice the
% frequency range of the preceding octave.
SA2 = dsp.SpectrumAnalyzer('SpectralAverages',50,'SampleRate',Fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log',...
    'RBWSource','Property','RBW',2000);
yw = zeros(Nx,Nfc);
tic,
while toc < 15
    % Run for 15 seconds
    xw = randn(Nx,1);
    for i=1:Nfc,
        yw(:,i) = filter(Hd3(i),xw);
    end
    step(SA2,yw);
end

%% Spectral Analysis of Pink Noise
% While a white noise signal has the same distribution of power for all
% frequencies, a pink noise signal has the same distribution of power for
% each octave, so the power between 0.5 Hz and 1 Hz is the same as between
% 5,000 Hz and 10,000 Hz. 
Hpink = dsp.ColoredNoise(1,Nx,1);
SA3 = dsp.SpectrumAnalyzer('SpectralAverages',50,'SampleRate',Fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log',...
    'YLimits', [-80 20]);
tic,
while toc < 15
    % Run for 15 seconds
    x = step(Hpink);
    step(SA3,x);
end
%%
% Now filter the pink noise signal with the 1/3-octave filter bank and
% compute the average power at the output of each filter. The power of the
% pink noise signal decline at higher frequencies at the rate of about -3dB
% per octave. However it sounds "constant" to the human hear and 1/3
% octave-band spectrum shows flat at the output of the filter bank.
SA4 = dsp.SpectrumAnalyzer('SpectralAverages',50,'SampleRate',Fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log',...
    'RBWSource','Property','RBW',2000);
y = zeros(Nx,Nfc);
tic,
while toc < 15
    % Run for 15 seconds
    x = step(Hpink);
    for i=1:Nfc,
        y(:,i) = filter(Hd3(i),x);
    end
    step(SA4,y);
end


displayEndOfDemoMessage(mfilename)
