function hF = createhdlfilter(this)
%CREATHDLFILTER <short description>
%   OUT = CREATHDLFILTER(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

hF = hdlfilter.mfiltcascade;
sethdl_cascade(this, hF);
% [EOF]