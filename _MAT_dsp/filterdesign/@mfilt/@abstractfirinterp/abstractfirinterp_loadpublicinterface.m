function abstractfirinterp_loadpublicinterface(this, s)
%ABSTRACTFIRINTERP_LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, 'InterpolationFactor', s.InterpolationFactor);

abstract_loadpublicinterface(this, s);

% [EOF]
