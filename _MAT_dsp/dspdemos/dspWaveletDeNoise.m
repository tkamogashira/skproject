%% Wavelet Denoising
% This example shows how to use the |DyadicAnalysis| and |DyadicSynthesis|
% System objects to remove noise from a signal.

%   Copyright 1995-2012 The MathWorks, Inc.

%% Introduction
% Wavelets have an important application in signal denoising. After wavelet
% decomposition, the high frequency subbands contain most of the noise
% information and little signal information. In this example, soft
% thresholding is applied to the different subbands. The threshold is set
% to higher values for high frequency subbands and lower values for low
% frequency subbands.

%% Initialization
% Creating and initializing the System objects before they are used in a
% processing loop is critical in obtaining optimal performance.

load dspwlets; % load wavelet coefficients and noisy signal
Threshold = [3 2 1 0];

%%
% Create a |SignalSource| System object to output the noisy signal.
hsfw = dsp.SignalSource(noisdopp.', 64);

%%
% Create and configure a |DyadicAnalysisFilterBank| System object for
% wavelet decomposition of the signal.
hdyadanalysis = dsp.DyadicAnalysisFilterBank( ...
    'CustomLowpassFilter', lod, ...
    'CustomHighpassFilter', hid, ...
    'NumLevels', 3);

%%
% Create three |Delay| System objects to compensate for the system delay
% introduced by the wavelet components.
hdelay1 = dsp.Delay(3*(length(lod)-1));
hdelay2 = dsp.Delay(length(lod)-1);
hdelay3 = dsp.Delay(7*(length(lod)-1));

%%
% Create and configure a |DyadicSynthesisFilterBank| System object for
% wavelet reconstruction of the signal.
hdyadsynthesis = dsp.DyadicSynthesisFilterBank( ...
    'CustomLowpassFilter', lor, ...
    'CustomHighpassFilter', hir, ...
    'NumLevels', 3);

%%
% Create time scope System object to plot the original, denoised and
% residual signals.
hts = dsp.TimeScope('Name', 'Wavelet Denoising', ...
  'SampleRate', fs, ...
  'TimeSpan', 13, ...
  'NumInputPorts', 3, ...
  'LayoutDimensions',[3 1], ...
  'TimeAxisLabels', 'Bottom');
pos = hts.Position;
hts.Position = [pos(1) pos(2)-(0.5*pos(4)) 0.9*pos(3) 2*pos(4)];

% Set properties for each display
hts.ActiveDisplay = 1;
hts.Title = 'Input Signal';

hts.ActiveDisplay = 2;
hts.Title = 'Denoised Signal';

hts.ActiveDisplay = 3;
hts.Title = 'Residual Signal';

%% Stream Processing Loop
% Create a processing loop to denoise the input signal. This loop uses the
% System objects you instantiated above.
for ii = 1:length(noisdopp)/64
    sig = step(hsfw);                  % Input noisy signal
    S = step(hdyadanalysis, sig);      % Dyadic analysis
    
    % separate into four subbands
    S1 = S(1:32);  S2 = S(33:48);  S3 = S(49:56);  S4 = S(57:64);

    % Delay to compensate for the dyadic analysis filters
    S1 = step(hdelay1, S1);
    S2 = step(hdelay2, S2);

    S1 = dspDeadZone(S1, Threshold(1));
    S2 = dspDeadZone(S2, Threshold(2));
    S3 = dspDeadZone(S3, Threshold(3));
    S4 = dspDeadZone(S4, Threshold(4));
    
    % Dyadic synthesis (on concatenated subbands)
    S = step(hdyadsynthesis, [S1; S2; S3; S4]);

    sig_delay = step(hdelay3, sig);   % Delay to compensate for
                                     % analysis/synthesis.
    Error = sig_delay - S;

    % Plot the results
    step(hts, sig_delay, S, Error);
end

%% Summary
% This example used signal processing System objects such as the
% |DyadicAnalysisFilterBank| and |DyadicSynthesisFilterBank| to denoise a
% noisy signal using user-specified thresholds. The Input Signal window
% shows the original noisy signal, the Denoised Signal window shows the
% signal after suppression of noise, and the Residue Signal window displays
% the error between the original and denoised signal.


displayEndOfDemoMessage(mfilename)
