function s = set_hiddenstates(h,s)
%SET_HIDDENSTATES Set the hidden states.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

Nest = get(h,'pathestord');

if (Nest ~= 0) & (length(s) ~= Nest),
    error(message('dsp:set_hiddenstates:incorrectNumberOfOutputStates'));
end

% Always store as a column
s = s(:);

