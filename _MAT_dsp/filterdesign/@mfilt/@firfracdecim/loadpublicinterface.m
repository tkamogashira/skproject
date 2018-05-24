function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if s.version.number == 0
    
    % If this is an R14 session we cannot load the states.
    s.States = [];
end

src_loadpublicinterface(this, s);

if s.version.number > 0
    set(this, 'PolyphaseAccum', s.PolyphaseAccum);
end

% [EOF]
