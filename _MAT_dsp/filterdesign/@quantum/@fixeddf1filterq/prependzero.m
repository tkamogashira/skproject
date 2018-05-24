function S = prependzero(q,S)
%PREPENDZERO   Prepend a zero to the numerator states.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

% Only prepend one zero to the numerator side of the states
prepend = fi(zeros(1,size(S,2)),'Signed',true,'WordLength',S.WordLength,...
    'FractionLength',S.FractionLength);
S = [prepend;S];

% [EOF]
