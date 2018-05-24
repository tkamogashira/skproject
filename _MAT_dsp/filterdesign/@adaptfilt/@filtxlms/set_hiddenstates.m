function s = set_hiddenstates(h,s)
%SET_HIDDENSTATES Set the hidden States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if ~isempty(s) & (length(s) ~= L-1),
    error(message('dsp:adaptfilt:filtxlms:set_hiddenstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

