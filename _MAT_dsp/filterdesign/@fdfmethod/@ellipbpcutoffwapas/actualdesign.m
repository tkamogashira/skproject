function Hd = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

N = get(specs, 'FilterOrder');

if rem(N, 2) == 1 || (rem(N,4)== 0 && any(strcmpi(this.FilterStructure,...
        {'cascadeallpass','cascadewdfallpass'}))),
    error(message('dsp:fdfmethod:ellipbpcutoffwapas:actualdesign:wrongOrder'));
end

% Design prototype filter for any fp, to keep things simple, we make fp
% equal to F3dB
hs = fspecs.lppassastop(N/2, specs.F3dB1, specs.Apass, ...
    max(specs.Astop1, specs.Astop2));
Hproto = ellip(hs,'FilterStructure',this.FilterStructure);
Hproto.setfdesign(hs);

% Find 3 db point
measurements = measure(Hproto);

% Apply frequency transformation to obtain final filter 
Hd = iirlp2bp(Hproto,measurements.F3dB,[specs.F3dB1,specs.F3dB2]);


% [EOF]
