function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

afnsfq_specifyall(this,flag);

if flag,
    tsm = 'SpecifyPrecision';
else
    tsm = 'KeepMSB';
end

this.TapSumMode = tsm;

% [EOF]
