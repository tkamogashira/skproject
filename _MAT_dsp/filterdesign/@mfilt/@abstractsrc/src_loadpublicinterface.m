function src_loadpublicinterface(this, s)
%SRC_LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, 'RateChangeFactors', s.RateChangeFactors);

if s.version.number > 0
    set(this, 'InputOffset', s.InputOffset);
end

abstract_loadpublicinterface(this, s);

% [EOF]
