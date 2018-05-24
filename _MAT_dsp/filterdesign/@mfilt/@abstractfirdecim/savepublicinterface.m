function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   Save the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = abstract_savepublicinterface(this);

s.DecimationFactor = get(this, 'DecimationFactor');
s.PolyphaseAccum   = get(this, 'PolyphaseAccum');
s.InputOffset      = get(this, 'InputOffset');

% [EOF]
