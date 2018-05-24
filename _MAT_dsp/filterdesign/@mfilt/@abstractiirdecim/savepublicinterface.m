function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

s = abstract_savepublicinterface(this);

s.InputOffset = this.InputOffset;
s.PolyphaseAccum = this.PolyphaseAccum;

% [EOF]
