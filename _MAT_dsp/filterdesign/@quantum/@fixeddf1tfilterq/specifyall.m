function specifyall(this,flag)
%SPECIFYALL   Set the object to full specified precision mode.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

afnsfq_specifyall(this,flag);

if flag,
    stateas = false;
else
    stateas = true;
end

this.StateAutoScale = stateas;

% [EOF]
