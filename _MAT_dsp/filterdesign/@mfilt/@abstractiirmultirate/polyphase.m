function p = polyphase(this,str)
%POLYPHASE   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

if nargout ,
    if nargin > 1 && strncmpi(str,'objects',length(str)),
        p = this.privPhase;
    else
        p = this.Polyphase;
    end
else
    h = fvtool(this, 'PolyphaseView', 'On', 'Analysis', 'coefficients');
end

% [EOF]
