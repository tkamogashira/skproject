function specifyall(this,flag)
%SPECIFYALL   Set the object to full specified precision mode.

%   Author(s): P. Costa
%   Copyright 1999-2003 The MathWorks, Inc.

% This code can be shared with the FIXEDDF1FILTERQ plug-in.

affq_specifyall(this,flag);

if flag,
    pmode = 'SpecifyPrecision';
    amode = pmode;
    stateas = false;
else
    pmode = 'FullPrecision';
    amode = 'KeepMSB';
    stateas = true;
end
           
this.ProductMode = pmode;
this.AccumMode = amode;
this.StateAutoScale = stateas;

% [EOF]
