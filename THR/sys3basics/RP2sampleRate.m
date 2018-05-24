function Fsam = RP2sampleRate(f);
% RP2sampleRate - exact sample rate [kHz] of RP2.
%    RP2sampleRate(Freq) returns the exact sample rate in kHz of the 
%    RP2 that is nearest to the requested frequency Freq [kHz].
%
%    RP2sampleRate('all') returns all available RP2 sample rates [kHz] in a
%    row vector.
%
%    See also TDTsampleRate, RX6sampleRate.

fixedSF = [6.103515625 12.20703125 24.4140625 48.828125 97.65625 195.3125];
if isequal('all',f), 
    Fsam = fixedSF;
else,
    % find the nearest one in that list
    [dum ifreq] = min(abs(f-fixedSF));
    Fsam = fixedSF(ifreq);
end




