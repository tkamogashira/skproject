function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

afnsfq_specifyall(this,flag);

if flag,
    sas = false;
else
    sas = true;
end

this.StateAutoScale = sas;

% [EOF]
