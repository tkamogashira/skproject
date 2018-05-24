function loadcoeffobj(this,s)
%LOADCOEFFOBJ   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

this.CoeffWordLength = s.CoeffWordLength;
this.CoeffAutoScale  = false;
set(this, 'CoeffFracLength', s.CoeffFracLength);
this.CoeffAutoScale  = s.CoeffAutoScale;
this.Signed          = s.Signed;


% [EOF]
