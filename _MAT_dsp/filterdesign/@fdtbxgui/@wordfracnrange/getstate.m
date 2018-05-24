function state = getstate(this)
%GETSTATE   Returns the current state of the object.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

% Grab the tag and version and all user specified settings (not the labels)
state.Tag          = this.Tag;
state.Version      = this.Version;
state.wordlength   = this.WordLength;

if strcmpi(this.AutoScaleAvailable, 'on')
    state.autoscale = this.AutoScale;
end

state.fraclengths  = this.FracLengths;
state.specifywhich = this.SpecifyWhich;
state.ranges       = this.Ranges;

% [EOF]
