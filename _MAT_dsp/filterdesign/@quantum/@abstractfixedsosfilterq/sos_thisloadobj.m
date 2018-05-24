function sos_thisloadobj(this, s)
%SOS_THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

iir_thisloadobj(this, s);

if ~this.CoeffAutoScale
    this.ScaleValueFracLength = s.ScaleValueFracLength;
end

% [EOF]
