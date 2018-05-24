function c = set_pathest(h,c)
%SET_PATHEST Set secondary path filter model coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

Nest = get(h,'pathestord');

if (Nest ~= 0) & (length(c) ~= Nest + 1),
    error(message('dsp:set_pathest:incorrectNumberOfOutputStates', Nest + 1));
end

% Always store as a row
c = c(:).';

