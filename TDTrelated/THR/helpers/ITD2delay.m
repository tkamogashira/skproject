function [Delay, S] = ITD2delay(ITD, EXP);
% ITD2delay - convert ITD to per-channel delay
%    ITD2delay(ITD, EXP) returns a 2-element array [dleft, dright] or scalar
%    specifying the delays that realize the specified ITD. The per-channel
%    delays dleft and dright are non-negative delays, one of which equals 
%    zero. EXP is the experiment, whose Preference field is needed to convert 
%    the ipsi/contra-based ITD spec to the left/right-based delay spec.
%
%    A scalar is returned only when ActiveAudioChan(EXP) is not Both, i.e., 
%    when only a single DA channel is available. A two-element array is 
%    returned whenever both DA channels are available, even when only one 
%    is active. The scalar value of the delay is evaluated by selecting 
%    first the dual-channel value and then selecting the available channel. 
%    This is done to ensure complete consistency between true binaural 
%    measurements and measurements in which monaural responses are used to 
%    construct a quasi binaural response, e.g., through crosscorrelation.
%
%    When ITD is a column vector, ITD2delay returns a Nx2 matrix or column
%    vector.
%
%    ITD2delay is a helper function for waveform calculators like toneStim
%    and noiseStim.
%
%    [Delay, S] = ITD2delay(ITD, EXP) also returns a struct with fields L
%    and R, containing the delays for channels L and R, if present.
%
%    See also IPD2phaseShift, IFD2freqShift, toneStim, noiseStim,
%    makeStimFS.

if ~isequal(1,size(ITD,2)),
    error('ITD input must be scalar or row array.')
end

% first compute Delay assuming ITD>0 means LeftLeading ..
Delay = [0*ITD ITD]-min(0*ITD,ITD)*[1 1];
% .. but ITD might really mean RightLeading 
IpsiIsLeft = isequal('Left', EXP.RecordingSide);
switch EXP.ITDconvention
    case 'IpsiLeading', % swap if ipsi=right 
        DoSwap = ~IpsiIsLeft;
    case 'ContraLeading', % swap if ipsi=left 
        DoSwap = IpsiIsLeft;
   case 'LeftLeading',
        DoSwap = false;
    case 'RightLeading',
        DoSwap = true;
    otherwise,
        error('Invalid ITDconvention value in Experiment.');
end 
if DoSwap,
    Delay = fliplr(Delay);
end
% reduce to Delay scalar if only a single DA channel is available
if isequal('Left', EXP.AudioChannelsUsed), 
    Delay = Delay(:,1); % Left
    S.L = Delay;
elseif isequal('Right', EXP.AudioChannelsUsed), 
    Delay = Delay(:,2); % Right
    S.R = Delay;
else,
    S.L = Delay(:,1);
    S.R = Delay(:,2);
end







