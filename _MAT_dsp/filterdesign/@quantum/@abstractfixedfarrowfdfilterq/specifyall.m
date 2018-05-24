function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

afd_specifyall(this,flag);

if flag,
    this.CoeffAutoScale = false;
else
    this.CoeffAutoScale = true;
end


% [EOF]
