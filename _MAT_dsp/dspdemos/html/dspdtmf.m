%% DTMF Generator and Receiver
% This example shows how to model a dual-tone multifrequency (DTMF)
% generator and receiver.  The model includes a bandpass filter bank
% receiver, a spectrogram plot of the generated tones, and a shift register
% to store the decoded digits.
% An alternate form of the example, <matlab:dspdtmf_audio dspdtmf_audio.mdl>,
% includes real-time soundcard audio on all platforms except Solaris(TM).

% Copyright 2005-2012 The MathWorks, Inc.

%% DTMF Generator
% DTMF signaling uses two tones to represent each key on the touch pad. There
% are 12 distinct tones. When any key is pressed the tone of the column and the
% tone of the row are generated. As an example, pressing the '5' button
% generates the tones 770 Hz and 1336 Hz. In this example, use the number 10 to 
% represent the '*' key and 11 to represent the '#' key.
%
% The frequencies were chosen to avoid harmonics: no frequency is a multiple of
% another, the difference between any two frequencies does not equal any of the
% frequencies, and the sum of any two frequencies does not equal any of the
% frequencies.
%
% The frequencies of the tones are as follows:
%
%          1209 Hz    1336 Hz    1477 Hz
%
%  697 Hz    1          2          3
%  770 Hz    4          5          6
%  852 Hz    7          8          9
%  941 Hz    *          0          #

%% DTMF Receiver

% At the receiver the tone frequencies are detected and the number decoded. The
% DFT algorithm can be used to detect frequencies, but since there are only 7
% frequency components (4 low frequencies and 3 high frequencies), a more
% efficient method is the Goertzel algorithm. This method detects the frequency
% components by passing the received signal through 7 bandpass filters. The
% filter bandwidths are adjustable as a percentage of the center frequency by
% adjusting the bandwidth parameter on the DTMF Receiver block mask.

%% Running the Example
% When you run the simulation, the spectrogram of the received tone will be
% constructed. If you use the version of the model designed for audio
% hardware, the received tone is played through the system soundcard. The
% detected dialed numbers will be shown on the numeric display scope. The
% following parameters can be adjusted:
%
% * Frequency bias for each tone (from the DTMF Generator mask dialog)
% * Channel noise power and signal gain (from the Channel mask dialog)
% * Receiver bandpass filter frequency bandwidth (from the DTMF Receiver mask dialog)

%% Example Model
open_system('dspdtmf');
sim('dspdtmf');
%%
bdclose dspdtmf

%% Available Example Versions
% Floating-point version: <matlab:dspdtmf dspdtmf.mdl>
%
% Floating-point version using audio hardware: <matlab:dspdtmf_audio dspdtmf_audio.mdl>
