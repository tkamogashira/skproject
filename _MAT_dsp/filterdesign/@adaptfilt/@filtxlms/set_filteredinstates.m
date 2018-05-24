function s = set_filteredinstates(h,s)
%SET_FILTEREDINSTATES Set the FilteredInStates.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

% Set States as hidden States
set(h,'hiddenStates',s);

warnifreset(h, 'FilteredInputStates');


