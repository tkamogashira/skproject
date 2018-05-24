function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003-2004 The MathWorks, Inc.

if nargin < 2,
    flag = true;
end

% Call specifyall on filterquantizer
specifyall(this.filterquantizer,flag);

% [EOF]
