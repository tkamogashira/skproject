function loadpublicinterface(this,s)
%LOADPUBLICINTERFACE   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

abstract_loadpublicinterface(this, s);

set(this, 'InputOffset',    s.InputOffset, ...
              'PolyphaseAccum', s.PolyphaseAccum);

% [EOF]
