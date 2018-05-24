function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

affq_specifyall(this,flag);

if flag,
    this.Filterinternals = 'SpecifyPrecision';    
else
    this.Filterinternals = 'FullPrecision';    
end
% [EOF]
