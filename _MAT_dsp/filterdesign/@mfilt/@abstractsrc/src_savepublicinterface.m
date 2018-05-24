function s = src_savepublicinterface(this)
%SRC_SAVEPUBLICINTERFACE   Save the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = abstract_savepublicinterface(this);

s.RateChangeFactors = get(this, 'RateChangeFactors');
s.InputOffset       = get(this, 'InputOffset');

% [EOF]
