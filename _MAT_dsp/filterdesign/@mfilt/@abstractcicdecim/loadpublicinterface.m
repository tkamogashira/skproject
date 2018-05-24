function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

cic_loadpublicinterface(this, s);

set(this, 'DecimationFactor', s.DecimationFactor);

if s.version.number > 0
    set(this, 'InputOffset', s.InputOffset);
else
    set(this, 'SectionWordLengths', s.BitsPerStage);
end

% [EOF]
