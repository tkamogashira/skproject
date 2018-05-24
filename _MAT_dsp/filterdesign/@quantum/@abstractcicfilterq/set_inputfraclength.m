function ifl = set_inputfraclength(this, ifl)
%SET_INPUTFRACLENGTH   PreSet function for the 'inputfraclength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

set(this, 'privInputFracLength', ifl);

% Update all internals including states
sendupdate(this);

ifl = [];

% [EOF]
