function b = isfilterinternals(this)
%ISFILTERINTERNALS   True if the object is filterinternals.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

if isa(this.Filter, 'mfilt.abstractcic')
    b = true;
else
    b = issupported(this);
    if b
        b = false;
        info = qtoolinfo(this.Filter);
        if isfield(info, 'filterinternals')
            b = info.filterinternals;
        end
    end
end

% [EOF]
