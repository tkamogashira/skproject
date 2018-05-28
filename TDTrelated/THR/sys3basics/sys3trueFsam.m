function Fsam = sys3trueFsam(Fsam,Dev);
% sys3trueFsam - exact sample rate [kHz] of sys3 device.
%    sys3trueFsam(Freq,Dev) returns the exact sample rate in kHz of the 
%    sys3 device Dev that is nearest to the requested frequency Freq [kHz].
%
%    See also RP2samplerate, Rx6sampleRate.

switch upper(Dev(1:3))
    case 'RP2',
        Fsam = RP2sampleRate(Fsam);
    case 'RX6',
        Fsam = RX6sampleRate(Fsam);
    otherwise,
        error(['Please teach me the sample rates of the ''' Dev ''' device.']);
end


