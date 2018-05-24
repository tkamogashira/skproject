function afnsfq_specifyall(this,flag)
%AFNSFQ_SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

afofq_specifyall(this,flag);

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
