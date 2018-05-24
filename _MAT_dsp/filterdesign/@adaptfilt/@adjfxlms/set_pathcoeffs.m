function c = set_pathcoeffs(h,c)
%SET_PATHCOEFFS Set secondary path filter coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

Npath = get(h,'pathord');

if (Npath ~= 0) & (length(c) ~= Npath + 1),
    error(message('dsp:set_pathcoeffs:incorrectNumberOfOutputStates', Npath + 1));
end

% Always store as a row
c = c(:).';

