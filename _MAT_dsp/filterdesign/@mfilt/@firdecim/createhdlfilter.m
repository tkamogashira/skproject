function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.firdecim;

this.sethdl_abstractpolyphase(hF);
hF.DecimationFactor = this.Decimationfactor;
hF.PolyphaseCoefficients = polyphase(this);

% [EOF]
