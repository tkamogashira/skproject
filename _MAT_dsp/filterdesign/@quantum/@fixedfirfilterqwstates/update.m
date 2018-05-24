function new = update(this, s)
%UPDATE  Converts to new fixed-point filter quantizer for DFFIRT 

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin > 1
    this = s;
end

new = quantum.fixeddffirtfilterq;

new.CoeffWordLength = this.CoeffWordLength;
new.CoeffAutoScale = false;
new.NumFracLength = this.NumFracLength;
new.CoeffAutoScale = this.CoeffAutoScale;
new.Signed = this.Signed;

new.InputWordLength = this.InputWordLength;
new.InputFracLength = this.InputFracLength;

new.FilterInternals = 'SpecifyPrecision';
new.OutputWordLength = this.OutputWordLength;
new.OutputFracLength = this.OutputFracLength;
new.ProductWordLength = this.ProductWordLength;
new.ProductFracLength = this.ProductFracLength;
new.AccumWordLength = this.AccumWordLength;
new.AccumFracLength = this.AccumFracLength;
new.RoundMode = this.RoundMode;
new.OverflowMode = this.OverflowMode;


% [EOF]
