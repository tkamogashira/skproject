function varargout = actualdesign(this,hspecs)
%ACTUALDESIGN   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

N = hspecs.FilterOrder;
Fc = hspecs.F0;
if hspecs.NormalizedFrequency,
    Fs = 2;
else
    Fs = hspecs.Fs;
end
b = 1/hspecs.privBandsPerOctave;

G = 10^(3/10);
f1 = Fc*(G^(-b/2)); 
f2 = Fc*(G^(b/2)); 
fmeth = fmethod.butterbp;
hs = fspecs.bp3db(N,f1,f2,Fs);
varargout{1} = actualdesign(fmeth,hs);


% [EOF]
