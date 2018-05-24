function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sos2_thisloadobj(this, s);

if s.version.number < 2
    sifl = s.StageInputFracLength;
    sofl = s.StageOutputFracLength;
else
    sifl = s.SectionInputFracLength;
    sofl = s.SectionOutputFracLength;
end

set(this, 'SectionInputFracLength', sifl, ...
    'SectionOutputFracLength', sofl, ...
    'StateAutoScale', s.StateAutoScale);

if ~this.StateAutoScale
    set(this, 'StateFracLength', s.StateFracLength);
end

% [EOF]
