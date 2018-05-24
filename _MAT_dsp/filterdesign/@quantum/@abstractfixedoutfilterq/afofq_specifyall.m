function afofq_specifyall(this,flag)
%AFOFQ_SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

affq_specifyall(this,flag);

if flag,
    om = 'SpecifyPrecision';    
else
    om = 'AvoidOverflow';
end

this.OutputMode = om;

% [EOF]
