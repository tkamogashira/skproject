function afd_specifyall(this,flag);
%AFD_SPECIFYALL   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

if flag,
    this.Filterinternals = 'SpecifyPrecision';
else
    this.Filterinternals = 'FullPrecision';
end

% [EOF]
