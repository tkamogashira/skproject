function coeffs = actualdesign(this,hspecs)
%ACTUALDESIGN

%   Copyright 2009 The MathWorks, Inc.

% Set the mask in the hspecs object
setmaskspecs(hspecs);
Fs = hspecs.ActualDesignFs;

if Fs <= 10e3
    warning(message('dsp:fdfmethod:bell41099audioweight:actualdesign:LowFsIIRDesign'));
end

p1 = -1502+1i*1267;
p2 = -2439+1i*5336;
p3 = -4690+1i*15267;
p4 = -4017+1i*21575;
pV = [p1; conj(p1);  p2; conj(p2); p3; conj(p3); p4; conj(p4)];
zV = [0 0 0].';

K = 5.0178e+020;

% Use impulse invariance to transform analog poles to a digital transfer
% function.
[Num, Den] = zp2tf(zV,pV,K);
[B,A] = impinvar(Num,Den,Fs);

% Measure response at 1e3 KHz and correct scale so that attenuation at this
% frequency is exactly 0 dB as required by the Bell System Technical Reference
% 41009 standard.
if Fs > 2e3
    K = correctScale(this,B,A,K,Fs);
    Num = [K 0 0 0];
    [B,A] = impinvar(Num,Den,Fs);
end
% Get rid of very small (close to zero) imaginary components
B = real(B);
A = real(A);

% Transform the response to SOS sections
[s,g] = tf2sos(B,A);
coeffs = {s,g};

function K = correctScale(~,B,A,K,Fs)
% Use freqz with a vector of frequencies as input. We are only interested in the
% magnitude response at the second frequency value (the reference frequency) but
% need to pass two frequency values to be able to use this format of freqz that
% computes the frequency response at a given set of frequency values (this
% format does not accept a scalar frequency point).
Resp = abs(freqz(B,A,[0 1000],Fs));
K = K/Resp(2);

% [EOF]
