function fl = getfraclengths(this, fl)
%GETFRACLENGTHS   Get the fraclengths.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

fl = get(this, 'privFracLengths');

if isempty(fl),
    fl = {'15'};
else
    fl = fl(1:length(this.FracLabels));
end

% [EOF]
