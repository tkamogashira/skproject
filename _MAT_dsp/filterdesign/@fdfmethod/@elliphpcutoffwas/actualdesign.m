function Hd = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

N = specs.FilterOrder;
if rem(N,2)== 0,
    error(message('dsp:fdfmethod:elliphpcutoffwas:actualdesign:evenOrder'));
end

Fc = specs.F3dB;
Ast = specs.Astop;

% Create temp fdesign
hf = fdesign.halfband('N,Ast',N,Ast);
he = ellip(hf,'FilterStructure',this.FilterStructure);

Hd = iirlp2hp(he,0.5,Fc);

% [EOF]
