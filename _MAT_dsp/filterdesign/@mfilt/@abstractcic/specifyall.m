function specifyall(this,flag)
%SPECIFYALL   Set the object to SpecifyWordLengths mode.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 2,
    flag = true;
end

% Call specifyall on filterquantizer
specifyall(this.filterquantizer,flag);

% [EOF]
