function resetpolym(Hm,num)
%RESETPOLYM Reset the polyphase matrix.

%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

M = Hm.DecimationFactor;

P = firpolyphase(num, M);

Hm.PolyphaseMatrix = P;
