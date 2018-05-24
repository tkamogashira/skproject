function sethdl_abstractpolyphase(this, hhdl)
%SETHDL_ABSTRACTPOLYPHASE Set the properties of hdlfiltercomp (hhdl) from the
%filter object.

%   Copyright 2007 The MathWorks, Inc.
this.sethdl_abstractfilter(hhdl);
[hhdl.RoundMode, hhdl.OverflowMode] = conv2hdlroundoverflow(this);

hhdl.PolyphaseCoefficients = polyphase(this);

hhdl.CoeffSLType = conv2sltype(this.filterquantizer, 'CoeffWordlength', 'NumFraclength');
hhdl.ProductSLType = conv2sltype(this.filterquantizer, 'ProductWordLength', 'ProductFracLength', true);
hhdl.AccumSLType = conv2sltype(this.filterquantizer, 'AccumWordLength', 'AccumFracLength', true);
% [EOF]
