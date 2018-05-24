function this = dfsymfirreport(datatype,in,out,prod,acc,tapsum)
%DFSYMFIRREPORT   Construct a DFSYMFIRREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.dfsymfirreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.TapSum = tapsum;

% [EOF]
