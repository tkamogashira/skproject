function Dphase = IPD2phaseShift(IPD, EXP);
% IPD2phaseShift - convert IPD to per-channel phase shift
%    IPD2phaseShift(IPD, EXP) returns a 2-element array [dleft, dright] or 
%    scalar specifying the phase shift that realize the specified IPD. 
%    The per-channel phase shifts dleft and dright are non-positive phase 
%    shifts (i.e., phase lags), one of which equals zero. EXP is the 
%    experiment, whose Preference field is needed to convert the 
%    ipsi/contra-based IPD spec to the left/right-based delay spec. The 
%    interpretation of IPDs follows the same convention as the 
%    interpretation of ITDs, namely, the disparity is realized in the
%    *lagging* channel, whereas the leading channel is unaffected.
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
%    When IPD is a column vector, ITD2phaseShift returns a Nx2 matrix or 
%    column vector.
%
%    ITD2phaseShift is a helper function for waveform calculators like 
%    toneStim and noiseStim.
%
%    See also ITD2delay, IFD2freqShift, toneStim, noiseStim, makeStimFS.

if ~isequal(1,size(IPD,2)),
    error('IPD input must be scalar or row array.')
end

% abuse ITD2delay, wich has the same convention
Dphase = -ITD2delay(IPD, EXP); % minus sign because neg phase = lag





