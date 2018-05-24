function s = getstate(this)
%   Copyright 1999-2002 The MathWorks, Inc.

% Get all the states that we want to save later.
s.checkbox           = this.checkbox;
s.quantizerclass     = this.quantizerclass;
s.mode               = this.mode;
s.roundmode          = this.roundmode;
s.overflowmode       = this.overflowmode;
s.fixedformat        = this.fixedformat;
s.floatformat        = this.floatformat;

