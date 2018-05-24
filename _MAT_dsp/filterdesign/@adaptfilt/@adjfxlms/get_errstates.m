function s = get_errstates(h,dummy)
%GET_ERRSTATES Get the error States property.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

% Get value
s = get(h,'hiddenStates');

