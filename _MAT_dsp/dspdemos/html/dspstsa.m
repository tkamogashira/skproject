%% Short-Time Spectral Attenuation
% This example shows removal of wideband noise from a speech signal using
% the Short-Time FFT and Inverse Short-Time FFT blocks. Use the switch
% before the 'To Audio Device' block to listen to the noisy or denoised
% signal.
%%

% Copyright 2005-2013 The MathWorks, Inc.

open_system('dspstsa');
%%
bdclose dspstsa
