function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   Save public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = src_savepublicinterface(this);

s.PolyphaseAccum = get(this, 'PolyphaseAccum');

% [EOF]
