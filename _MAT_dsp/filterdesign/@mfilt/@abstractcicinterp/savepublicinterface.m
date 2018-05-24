function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   Save the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = cic_savepublicinterface(this);

s.InterpolationFactor = get(this, 'InterpolationFactor');

% [EOF]
