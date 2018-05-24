function setstate(this,s)
%SETSTATE Set the state of the object

%   Copyright 2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

% Set the input processing option. If loading from a pre R2011b block, then
% set input processing to inherited. 
setInputProcessingState(this,s);

siggui_setstate(this, s);

% [EOF]
