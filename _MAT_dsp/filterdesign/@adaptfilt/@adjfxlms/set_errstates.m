function s = set_errstates(h,s)
%SET_ERRSTATES Set the error States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

% Set States as hidden States
set(h,'hiddenStates',s);

warnifreset(h, 'ErrorStates');


