function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

Snum = fi(0,'Signed',true,'WordLength',q.NumStateWordLength,...
    'FractionLength',q.NumStateFracLength);
Sden = fi(0,'Signed',true,'WordLength',q.DenStateWordLength,...
    'FractionLength',q.DenStateFracLength);

S = filtstates.dfiir(Snum,Sden);

% [EOF]
