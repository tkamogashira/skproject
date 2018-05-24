function [Fsam, dt] = sampleRate(Freq, EXP);
% sampleRate - safe sample rate to realize stimulus waveforms
%    sampleRate(Fstim, EXP) returns the sample rate in Hz suitable for
%    sampling stimuli having frequency Fstim in Hz. If Fstim is a matrix,
%    its maximum value is used. EXP is the Experiment, which contains
%    the system parameters that codetermine the sample rate: particularly
%    minFsam(EXP) defines a hard minimum for the sample rate.
%
%    [Fsam, dt] = sampleRate(...) also returns the sample period in ms.
%
%    See also RX6sampleRate, RP2sampleRate, toneStim, makeStimFS, 
%    Experiment/minFsam.


switch EXP.AudioDevice(1:3),
    case 'RX6',
        SampleFreqs = 1e3*RX6sampleRate('all'); % kHz -> Hz
        NyqFactor = 2.5; % min ratio of Fstim/Fsam
    case 'RP2',
        SampleFreqs = 1e3*RP2sampleRate('all'); % kHz -> Hz
        NyqFactor = 2.5; % min ratio of Fstim/Fsam
    otherwise,
        error(['Unknown DAC hardware device ''' CT.Hardware.DAC '''.']);
end
    
Freq = max(Freq(:)); % grand max determines sample rate
FsamMin = max(1e3*minFsam(EXP), NyqFactor*Freq); % strict minimum; also acounting for ADC rate needed in recordings (if any)
% return smallest sample rate that is still big enough
Fsam = min(SampleFreqs(SampleFreqs>=FsamMin));
% check against max sample rate allowed on this setup
if isempty(Fsam),
    dt = [];
else,
    dt = 1e3/Fsam;
end





