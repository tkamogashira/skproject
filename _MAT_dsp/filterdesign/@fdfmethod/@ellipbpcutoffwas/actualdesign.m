function Hd = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

N = specs.FilterOrder;
if rem(N,4)== 0 || rem(N,2) ~= 0,
    error(message('dsp:fdfmethod:ellipbpcutoffwas:actualdesign:wrongOrder'));
end

Fc1 = specs.F3dB1;
Fc2 = specs.F3dB2;
Ast = specs.Astop;

% Create temp fdesign
hf = fdesign.halfband('N,Ast',N/2,Ast);
he = ellip(hf,'FilterStructure',this.FilterStructure);

Hd = iirlp2bp(he,0.5,[Fc1,Fc2]);

% [EOF]
