function setunits(this, units)
%SETUNITS   PreSet function for the 'units' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = handles2vector(this);

set(h, 'Units', units);

h = allchild(this);

for indx = 1:length(h)
    setunits(h(indx), units);
end

set(this.Handles.java.controller.decimation, 'Units', units);
set(this.Handles.java.controller.interpolation, 'Units', units);

% [EOF]
