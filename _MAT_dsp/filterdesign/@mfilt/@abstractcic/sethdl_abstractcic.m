function sethdl_abstractcic(this, hhdl)
%SETHDL_ABSTRACTCIC Set the properties of hdlfiltercomp (hhdl) from the
%filter object.

%   Copyright 2007 The MathWorks, Inc.
this.sethdl_abstractfilter(hhdl);
[hhdl.RoundMode, hhdl.OverflowMode] = conv2hdlroundoverflow(this);
hhdl.NumberOfSections = this.numberofsections;
hhdl.DifferentialDelay = this.differentialdelay;

swl = this.SectionWordlengths;
sfl = this.SectionFraclengths;
numsections = length(this.SectionWordlengths);

sltype = cell(1,numsections);
for n = 1:numsections
    sltype{n} = hdlgetsltypefromsizes(swl(n), sfl(n) , true); % always fixed
end
hhdl.SectionSLType = sltype;




% [EOF]
