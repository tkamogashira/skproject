function state = getstate(this)
%GETSTATE   Returns the current state of the object.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

% Grab the tag and version and all user specified settings (not the labels)
state.Tag          = this.Tag;
state.Version      = this.Version;
state.wordlength   = this.WordLength;
state.autoscale    = this.Autoscale;
state.fraclengths  = this.FracLengths;

% [EOF]
