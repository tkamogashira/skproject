function [Amp, Phase, maxSPL] = ToneComplexLevelChecking(Amp, Phase, CalibParams, maxSampleMag, ampWeight);
% ToneComplexLevelChecking - sample amplitudes and attenuator settings for tone complexes
%   [Amp, Phase, MaxSPL, Atten] = ToneComplexLevelChecking(Amp, Phase, CP, maxMagSample) 
%   finds the linear amplitudes and phases of the components of a tone complex.
%   The input parameters Amp and Phase contain the linear amplitudes (in AU) 
%   and the phases (in cycles) of the components without calibration. CP is
%   cell array of ipnput arguments to Calibrate, in such a way that 
%       [Camp Cph]= Calibrate(CP{:}) returns the calibration amplitude factors Camp
%   and phase correction Cph of the components according to the (current) calibration.
%   Usually, CP is of the form {freq, ifilt, chan}. See Calibrate.
%   MaxMagSample is the maximum magnitude of the samples to be sent to the D/A converter.
%   MaxMagSample defaults to the value returned by maxMagDA.
%   Output arguments:
%    Amp & Phase are the linear amplitudes and phases of the components as used
%         for the sample buffers, that is they are the corresponding input
%         Amp and Phase corrected for calibration characteristics.
%         Amp is maximized - it is the highest scaling possible without exceeding
%         maxMagSample.
%    MaxSPL is the SPL of the *carrier* when the buffers are played without any
%         analog attenuation.
%
%   ToneComplexLevelChecking(Amp, Phase, CP, maxMagSample, ampWeight) uses ampWeight.*Amp
%   for the specification of maxSPL. This can be used for singling out one components as
%   an SPL reference (e.g. the carrier of a SAM complex).
%   
%   See also ToneComplex, stimDefinitionFS, maxMagDA, Calibrate.

if nargin<4, maxSampleMag = maxMagDA; end;
if nargin<5, ampWeight = 1; end

% avoid trivial fuss
if all(Amp==0), maxSPL = -inf; return; end

% SPL as if the current amplitudes are all specidied re 20 uPa
% (Calibrate will respect this convention)
numSPL = a2db(rms(ampWeight.*Amp)); % ampWeight allows singling-out of, say, carrier

% apply calibration scaling factors and phase correction
[calAmp, calPhase] = calibrate(CalibParams{:});
Amp = Amp * db2a(calAmp); % these amplitudes, when sent to the D/A, will result in a sound level of numSPL dB
Phase = Phase + calPhase;
      
% up-scaling of amplitudes to just hit the max magnitude
margin = maxSampleMag/sum(abs(Amp));
Amp = Amp*margin;

% maximum SPL is corrected numSPL
maxSPL = numSPL + a2db(margin);

return

atten = a2db(margin);
atten = 0.1*floor(atten*10);
amps = amps*db2a(atten);

if atten<0, % try to get rid of some atten at the price of disregaring minAtten
   gain = min(minAtten, -atten); % cannot relax more than minAtten, that would violate maxSampleMag
   amps = amps*db2a(gain);
   atten = atten+gain;
end
% impose hard max
if atten>maxAtten,
   amps = amps*db2a(maxAtten-atten);
   atten = maxAtten;
end

if atten<0,
   mess = 'Level too high';
end








