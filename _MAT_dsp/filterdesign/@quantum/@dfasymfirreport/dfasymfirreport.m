function this = dfasymfirreport(datatype,in,out,prod,acc,tapsum)
%DFASYMFIRREPORT   Construct a DFASYMFIRREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.dfasymfirreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.TapSum = tapsum;

% [EOF]
