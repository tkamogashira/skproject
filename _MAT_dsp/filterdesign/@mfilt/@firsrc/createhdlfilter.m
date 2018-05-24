function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.firsrc;

this.sethdl_abstractpolyphase(hF);
hF.RateChangeFactors = this.RateChangeFactors;

% [EOF]
