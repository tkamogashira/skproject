function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.firinterp;
this.sethdl_abstractpolyphase(hF);
hF.InterpolationFactor = this.Interpolationfactor;
hF.PolyphaseCoefficients = polyphase(this);

% [EOF]
