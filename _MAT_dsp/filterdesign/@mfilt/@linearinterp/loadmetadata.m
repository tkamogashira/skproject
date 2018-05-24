function loadmetadata(this, s)
%LOADMETADATA   Load the meta data.

%   Copyright 1999-2011 The MathWorks, Inc.

if isstruct(s)
    hfd = s.fdesign;
    if s.version.number > 0
        hfm = s.fmethod;
    else
        hfm = [];
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
