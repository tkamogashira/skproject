function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if s.version.number == 1
    s.States = s.HiddenStates;
end

abstractfirdecim_loadpublicinterface(this, s);

% Force the Coefficients to update.
quantizecoeffs(this);

% [EOF]
