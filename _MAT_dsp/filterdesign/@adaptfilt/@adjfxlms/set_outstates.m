function s = set_outstates(h,s)
%SET_OUTSTATES Set the output states.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

Npath = get(h,'pathord');

if ~isempty(s) & (length(s) ~= Npath),
    error(message('dsp:set_outstates:incorrectNumberOfOutputStates'));
end

% Always store as a column
s = s(:);

warnifreset(h, 'SecondaryPathStates');
