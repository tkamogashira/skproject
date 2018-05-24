function resetpolym(Hm,num)
%RESETPOLYM Reset the polyphase matrix.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

% Fractional Decimators
P = firpolyphase(num, R(1));

Hm.PolyphaseMatrix = P;
