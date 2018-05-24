function afd_specifyall(this,flag);
%AFD_SPECIFYALL   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

if flag,
    this.FDAutoScale = false;    
    this.Filterinternals = 'SpecifyPrecision';
else
    this.FDAutoScale = true;    
    this.Filterinternals = 'FullPrecision';
end


% [EOF]
