function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.cicinterp;

this.sethdl_abstractcic(hF);
hF.InterpolationFactor = this.Interpolationfactor;

% [EOF]
