function sos2_thisloadobj(this, s)
%SOS2_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sos_thisloadobj(this, s);

if s.version.number < 2
    siwl = s.StageInputWordLength;
    sowl = s.StageOutputWordLength;
else
    siwl = s.SectionInputWordLength;
    sowl = s.SectionOutputWordLength;
end

set(this, ...
    'StateWordLength',       s.StateWordLength, ...
    'SectionInputWordLength',  siwl, ...
    'SectionOutputWordLength', sowl);

% [EOF]
