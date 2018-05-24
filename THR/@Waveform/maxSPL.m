function [mxSPL, Atten] = maxSPL(W, EXP);
% Waveform/maxSPL - maximum SPL of waveform 
%   maxSPL(W,EXP) returns the maximum SPL of the waveform W when it is played 
%   at max DAC amplitude with attenuators wide open. EXP is the Experiment
%   definition, some of howse parameters which codetermine the realization
%   of the waveform.
%
%   If W is a matrix, maxSPL returns a matrix of the same size as W.
%
%   [mxSPL, Atten] = maxSPL(W,EXP) also returns suggested attenuation
%   settings for playing the totality of waveforms contained in W. Atten is
%   a struct with fields
%      AnaAtten: attenuation [dB] by the analog attenuators. This is
%           always a pair of numbers [dBleft dBright]. If only one
%           channel is active, the attenuation for the other channel
%           is set to its maximum value.
%      NumScale: numerical scale factors to be applied to the scaled
%           waveforms prior to sending them to the DAC. NumScale has the
%           same size as W.
%
%    The attenuator settings are evaluated by considering the settings in 
%    EXP: the maximum analog attenuation of the specified attenuators and 
%    the preferred numerical attenuation PrefMinNumAtten.

DACmax = EXP.AudioMaxAbsDA;
[mxSPL, SPL] = deal(nan+zeros(size(W))); % correct size, all nans
for ii=1:numel(W),
    % Find out how much waveforms can be boosted w/o exceeding the
    % max magnitude DACmax tolerated by the DAC
    mxSPL(ii) = W(ii).SPL + a2db(DACmax/W(ii).MaxMagSam) - 0.1;
    SPL(ii) = W(ii).SPL;
end

Ncond = size(W,1);

AnaAtten = 0;
% Numerical amplification toward the ceiling is often possible as 
% long as it can be compensated by analog attenuation. Be aware that 
% the analog attenuator cannot be set during stimulus delivery. So the 
% extra gain must be applied to all stimuli in a given DAC channel.
Gain = min(mxSPL - SPL); % max along first dim, i.e. per channel=column
AnaAtten = Gain; % compensate the gain

% If there is enough clearance, use the preferred minimum numerical 
% attenuation at the cost of analog attenution. This may help reduce
% the amount of distortion occurring at high DAC output Voltages.
ExtraNumAtten = min(AnaAtten, EXP.PreferredNumAtten);
AnaAtten = AnaAtten - ExtraNumAtten;
Gain = Gain - SameSize(ExtraNumAtten, Gain);

% If the analog attenuation exceeds the range of the attenuator, replace
% part of it by numerical attenuation
switch EXP.Attenuators,
    case 'PA5', MaxAtten = 90; % dB max attenuation (higher range of PA5s is unreliable)
    case '-', MaxAtten = 0; % dB
    otherwise,
        error(['Unknown attenuators ''' EXP.Attenuators ''' specified.']);
end
AnaExcess = max(0,AnaAtten-MaxAtten);
AnaAtten = AnaAtten-AnaExcess;
Gain = Gain - AnaExcess;

% the analog attenuators are accurate to 0.1 dB. Take care of rounding
% errors.
RoundingCorrection = AnaAtten-0.1*floor(10*AnaAtten);
AnaAtten = AnaAtten-RoundingCorrection;
Gain = Gain - SameSize(RoundingCorrection, Gain);

Gain = samesize(Gain,W);
NumScale = db2a(Gain);
NumGain_dB = Gain; % for the record
Atten = CollectInStruct(AnaAtten, NumScale, NumGain_dB);








