function resetpolym(Hm,num)
%RESETPOLYM Reset the polyphase matrix.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

L = Hm.InterpolationFactor;

% Interpolation
P = firpolyphase(num, L);

Hm.PolyphaseMatrix = P;
