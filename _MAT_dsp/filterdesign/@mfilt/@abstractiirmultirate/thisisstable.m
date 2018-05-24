function b = thisisstable(this)
%THISISSTABLE   True if the object is stable.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


b = true;

for k = 1:length(this.privphase),
    b = b && isstable(this.privphase(k));
end

% [EOF]
