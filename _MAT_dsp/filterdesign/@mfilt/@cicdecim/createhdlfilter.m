function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.cicdecim;
this.sethdl_abstractcic(hF);
hF.DecimationFactor = this.DecimationFactor;
% [EOF]
