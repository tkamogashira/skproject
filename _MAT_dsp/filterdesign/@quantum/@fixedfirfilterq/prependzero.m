function S = prependzero(q,S)
%PREPENDZERO   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
prepend = fi(zeros(1,size(S,2)), 'Signed', true, 'WordLength', S.WordLength, ...
        'FractionLength', S.FractionLength, 'fimath', F);
S = [prepend;S];


% [EOF]
