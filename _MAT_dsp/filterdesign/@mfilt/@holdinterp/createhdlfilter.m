function hF = createhdlfilter(this)
%CREATEHDLFILTER Returns the corresponding hdlfiltercomp object 

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.holdinterp;
this.sethdl_abstractfilter(hF);
hF.InterpolationFactor = this.Interpolationfactor;

% [EOF]
