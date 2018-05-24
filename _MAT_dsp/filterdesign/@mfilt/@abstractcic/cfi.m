function fi = cfi(this)
%CFI   Return the information for the CFI.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rci = get(this, 'privRateChangeFactor');

fi.Structure  = get(this, 'FilterStructure');
fi.RateChange = sprintf('%d / %d', rci);
fi.Sections   = sprintf('%d', nsections(this));

% [EOF]
