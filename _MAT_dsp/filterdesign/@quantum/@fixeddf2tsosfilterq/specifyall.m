function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003-2004 The MathWorks, Inc.

if flag
    as = false;
else
    as = true;
end

this.StateAutoScale = as;

afnsfq_specifyall(this,flag);


% [EOF]
