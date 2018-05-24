function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

sos2_thisloadobj(this, s);

if s.version.number < 2
    sias = s.StageInputAutoScale;
    soas = s.StageOutputAutoScale;
else
    sias = s.SectionInputAutoScale;
    soas = s.SectionOutputAutoScale;
end

set(this, 'StateFracLength', s.StateFracLength, ....
    'SectionInputAutoScale', sias, ...
    'SectionOutputAutoScale',  soas);

if ~this.SectionInputAutoScale
    if s.version.number < 2
        sifl = s.StageInputFracLength;
    else
        sifl = s.SectionInputFracLength;
    end
    set(this, 'SectionInputFracLength', sifl);
end

if ~this.SectionOutputAutoScale
    if s.version.number < 2
        sofl = s.StageOutputFracLength;
    else
        sofl = s.SectionOutputFracLength;
    end
    set(this, 'SectionOutputFracLength', sofl);
end

% [EOF]
