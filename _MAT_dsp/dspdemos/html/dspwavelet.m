%% Wavelet Reconstruction and Noise Reduction
% This example uses the Dyadic Analysis Filter Bank and Dyadic Synthesis
% Filter Bank blocks to show both the perfect reconstruction property
% of wavelets and an application for noise reduction.
%% Exploring the Example
% Open the Operation block dialog and select either Remove noise or Perfect
% reconstruction. The selection will enable the corresponding enabled
% subsystem.
%
% Opening the Wavelet Reconstruction subsystem shows an Analysis
% Filter Bank followed by the Wavelet Reconstruction subsystem. The net
% effect of these two operations is perfect reconstruction of the input
% signal.
%
% Opening the Noise Reduction subsystem shows the same wavelet blocks but
% with a soft threshold applied to the transformed signal bands. By
% attenuating the higher frequency bands, the high frequency noise is
% reduced. You can adjust the threshold levels to see the effects of
% attenuation on the denoising characteristics of the system.
%
% Run the example to view the input and output signals and the difference
% between them. Note that for perfect reconstruction, the difference
% appears to be zero. However, due to numerical effects, there is a small
% difference that can be seen in the display of the running RMS display.

% Copyright 2008-2012 The MathWorks, Inc.

open_system('dspwavelet');
sim('dspwavelet');
%%
bdclose dspwavelet
%% Available Example Versions
% Floating-point sample-based version: <matlab:dspwavelet dspwavelet.mdl>
%
% Floating-point frame-based version: <matlab:dspwavelet_frame dspwavelet_frame.mdl>
%
% Fixed-point sample-based version: <matlab:dspwavelet_fixpt dspwavelet_fixpt.mdl>
