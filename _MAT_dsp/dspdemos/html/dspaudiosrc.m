%% Audio Sample Rate Conversion
% This example shows sample rate conversion of an audio signal from
% 22.050 kHz to 8 kHz using a multirate FIR rate conversion approach.

% Copyright 2005-2012 The MathWorks, Inc. 

%% Audio Sample Rates
% Digital audio recordings use many different sample rates such as 8 kHz,
% 11.025 kHz, 16 kHz, 22.05 kHz, 24 kHz, 44.1 kHz, 48 kHz, 96 kHz, etc. The
% lower rates are used for speech or low fidelity audio, while the higher
% rates are primarily used for high fidelity audio. Data is commonly
% resampled for use with different media or equipment. When lower fidelity
% is acceptable, resampling can reduce data storage requirements.
%
% There are many ways to convert a digital audio stream from 22.05 kHz
% to 8 kHz. The method illustrated in this example uses a single
% polyphase FIR rate conversion filter, which requires a relatively
% small number of operations at the expense of memory.

%% Exploring the Example
% The example uses an audio frequency sweep source (0 - 10 kHz) and DSP
% System Toolbox(TM) scope blocks to view the input (original) and output
% (resampled) audio signals in the time and frequency domains. The
% floating-point version of the example uses a Chirp block for its input,
% while the fixed-point version uses an NCO block.
%
% As the input signal goes above 4 kHz, the output essentially
% vanishes, since it is unrepresentable at the output sample rate.
% As the input goes below 4 kHz the output reappears.
%%
open_system('dspaudiosrc');
set_param('dspaudiosrc','StopTime','3');
set_param('dspaudiosrc','IntegerOverflowMsg','none');
bdclose('dspaudiosrc48to441_fixpt/Visualization/Scope');
sim('dspaudiosrc');
%%
%% See Also 
% "Designing Multirate and Multistage Filters" in the DSP System Toolbox(TM) 
% documentation.
% 
%%
bdclose dspaudiosrc
%%
%% References
% Fliege, N.J., *Mulitrate Digital Signal Processing*, John Wiley and Sons, 1994.
%
% Mitra, S.K., *Digital Signal Processing*, McGraw-Hill, 1998.
% 
% Orfanidis, S.J., *Introduction to Signal Processing*, Prentice-Hall, Inc., 1996.
%
% Vaidyanathan, P.P., *Multirate Systems and Filter Banks*, Prentice-Hall, Inc., 1993.

%% Available Example Versions
% Floating-point version: <matlab:dspaudiosrc dspaudiosrc.mdl>
%
% Fixed-point version: <matlab:dspaudiosrc_fixpt dspaudiosrc_fixpt.mdl>
