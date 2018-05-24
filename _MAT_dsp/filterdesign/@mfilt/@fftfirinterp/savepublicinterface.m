function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   Save the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = abstractfirinterp_savepublicinterface(this);

s.BlockLength         = get(this, 'BlockLength');
s.NonProcessedSamples = get(this, 'NonProcessedSamples');

% [EOF]
