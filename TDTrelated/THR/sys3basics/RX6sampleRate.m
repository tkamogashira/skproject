function Fsam = RX6sampleRate(f);
% RX6sampleRate - exact sample rate [kHz] of RX6.
%    RX6sampleRate(Freq) returns the exact sample rate in kHz of the 
%    RX6 that is nearest to the requested frequency Freq [kHz].
%
%    RX6sampleRate('all') returns all available RX6 sample rates [kHz] in a
%    row vector. This list is restricted by the maximum sample rate of the
%    current setup that is controlled by the maxFsamRX6 parameter of 
%    sys3setup.
%
%    See also RP2sampleRate, sys3setup.

% The valid set of divisors of the 50-MHz master clock is:

% divisor = [8192  7168  6144  5120  4096  3584  3072  2560  2048  1792  1536  1280  1024   896   768   640   512   448   384   320   256   224   192];
% fixedSF = 50e6./divisor;
% The above doesn't work due to single-precision shit in RPvdS
% Use hardcoded values
%fixedSF = [6.103515625 6.97544580078125 8.1380205078125 9.765625 12.20703125 13.9508916015625 16.276041015625 19.53125 24.4140625 27.901783203125 32.55208203125 39.0625 48.828125 55.80356640625 65.1041640625 78.125 97.65625 111.6071328125 130.208328125 156.25 195.3125 223.214265625 260.41665625];
% removed lowest few to avoid excessive noise over DA channels
fixedSF = [19.53125 24.4140625 27.901783203125 32.55208203125 39.0625 48.828125 55.80356640625 65.1041640625 78.125 97.65625 111.6071328125 130.208328125 156.25 195.3125 223.214265625 260.41665625];
fixedSF = fixedSF(fixedSF<=sys3setup('maxFsamRX6'));
if isequal('all',f), 
    Fsam = fixedSF;
else,
    % find the nearest one in that list
    [dum ifreq] = min(abs(f-fixedSF));
    Fsam = fixedSF(ifreq);
end




