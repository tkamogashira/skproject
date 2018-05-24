function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.firtdecim;

this.sethdl_abstractpolyphase(hF);
hF.DecimationFactor = this.Decimationfactor;
hF.PolyphaseCoefficients = polyphase(this);
hF.StateSLType = conv2sltype(this.filterquantizer, 'StateWordlength', 'StateFraclength', true);
hF.PolyAccumSLType = conv2sltype(this.filterquantizer, 'PolyAccWordlength', 'PolyAccFraclength', true);
% [EOF]
