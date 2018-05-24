function resetpolym(Hm,num)
%RESETPOLYM Reset polyphase matrix.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

% Create M polyphase subfilters
P = firpolyphase(num,R(2));
Hm.PolyphaseMatrix = P;

