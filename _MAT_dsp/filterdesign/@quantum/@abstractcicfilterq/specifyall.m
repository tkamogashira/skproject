function specifyall(this,flag)
%SPECIFYALL   Set the object to SpecifyWordLengths mode.

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

if flag,
    wlm = 'SpecifyPrecision';
else
    wlm = 'FullPrecision';
end
           
this.FilterInternals = wlm;

% [EOF]
