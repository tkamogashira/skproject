function Fsam = TDTsampleRate(Dev, f);
% TDTsampleRate - exact sample rate [kHz] of TDT device.
%    TDTsampleRate(Dev, Freq) returns the exact sample rate in kHz of
%    sys3 device Dev that is nearest to the requested frequency Freq [kHz].
%    Dev is one of 'RX6', 'RP2'. Postfixes as in 'RX6_1' are allowed.
%
%    TDTsampleRate(Dev, 'all') returns all available sample rates [kHz] in a
%    row vector.
%
%    See also RP2sampleRate, RX6sampleRate.

fh = fhandle([Dev(1:3) 'SampleRate']);
Fsam = fh(f);





