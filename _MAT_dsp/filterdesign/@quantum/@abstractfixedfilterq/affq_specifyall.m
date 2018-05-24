function affq_specifyall(this,flag)
%AFFQ_SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

if flag,
    cas = false;    
else
    cas = true;    
end

this.CoeffAutoScale = cas;

% [EOF]
