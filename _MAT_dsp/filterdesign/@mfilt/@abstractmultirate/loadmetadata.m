function loadmetadata(this, s)
%LOADMETADATA   Load the meta data.

%   Copyright 1999-2011 The MathWorks, Inc.

if isstruct(s)
    if s.version.number == 1
        hfd = s.privfdesign;
    else
        hfd = s.fdesign;
    end
    switch s.version.number
        case 0
            hfm = [];
        case 1
            hfm = s.privfmethod;
        otherwise
            hfm = s.fmethod;
    end
else
    hfd = getfdesign(s);
    hfm = getfmethod(s);
end

% Add the SystemObject property if it applies
if ~isempty(hfm) && isa(hfm,'fmethod.abstractdesign')
  addsysobjdesignopt(hfm);
end

setfdesign(this, hfd);
setfmethod(this, hfm);


% [EOF]
