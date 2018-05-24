function out_thisloadobj(this, s)
%OUT_THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

this.OutputWordLength = s.OutputWordLength;
this.OutputMode       = s.OutputMode;
if strcmpi(this.OutputMode, 'SpecifyPrecision')
    this.OutputFracLength = s.OutputFracLength;
end

% [EOF]
