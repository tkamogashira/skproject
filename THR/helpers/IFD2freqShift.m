function Dfreq = IFD2freqShift(IFD, EXP);
% IFD2freqShift - convert IPD to per-channel phase shift
%    IFD2freqShift(IPD, EXP) returns a 2-element array [dleft, dright] or 
%    scalar specifying the frequency shifts that realize the specified IFD. 
%    The per-channel freq shifts dleft and dright are non-positive frequency 
%    shifts (i.e., frequency decrements), one of which equals zero. EXP is the 
%    experiment, whose Preference field is needed to convert the 
%    ipsi/contra-based IFD spec to the left/right-based delay spec. The 
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
%    When IFD is a column vector, IFD2freqShift returns a Nx2 matrix or 
%    column vector.
%
%    IFD2freqShift is a helper function for waveform calculators like 
%    toneStim and noiseStim.
%
%    See also ITD2delay, IPD2phaseShift, toneStim, noiseStim, makeStimFS.

if ~isequal(1,size(IFD,2)),
    error('IFD input must be scalar or row array.')
end

% abuse ITD2delay, wich has the same convention
Dfreq = -ITD2delay(IFD, EXP); % minus sign because neg dfreq = freq decrement





