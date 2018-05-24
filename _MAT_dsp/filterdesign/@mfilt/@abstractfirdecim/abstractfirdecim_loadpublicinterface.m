function abstractfirdecim_loadpublicinterface(this, s)
%ABSTRACTFIRDECIM_LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, 'DecimationFactor', s.DecimationFactor);

abstract_loadpublicinterface(this, s);

if s.version.number == 0
    if ~isempty(s.PhaseIndex)
        M = s.DecimationFactor;
        set(this, 'InputOffset', mod(M - mod(s.PhaseIndex, M), M));
    end
else
    set(this, 'InputOffset',    s.InputOffset, ...
              'PolyphaseAccum', s.PolyphaseAccum);
end

% [EOF]
