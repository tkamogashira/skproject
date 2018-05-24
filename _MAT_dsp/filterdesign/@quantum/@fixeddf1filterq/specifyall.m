function specifyall(this,flag)
%SPECIFYALL   Set the object to full specified precision mode.

%   Author(s): P. Costa
%   Copyright 1999-2003 The MathWorks, Inc.

affq_specifyall(this,flag);

if flag,
    pmode = 'SpecifyPrecision';
    amode = pmode;
else
    pmode = 'FullPrecision';
    amode = 'KeepMSB';
end
           
this.ProductMode = pmode;
this.AccumMode = amode;

% [EOF]
