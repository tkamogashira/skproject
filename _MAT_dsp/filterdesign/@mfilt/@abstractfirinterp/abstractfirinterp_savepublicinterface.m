function s = abstractfirinterp_savepublicinterface(this)
%ABSTRACTFIRINTERP_SAVEPUBLICINTERFACE   Save the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = abstract_savepublicinterface(this);

s.InterpolationFactor = get(this, 'InterpolationFactor');

% [EOF]
