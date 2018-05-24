function this = linearfdreport(datatype,in,out,prod,acc,tapsum)
%LINEARFDREPORT   Construct a LINEARFDREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

this = quantum.linearfdreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.TapSum = tapsum;

% [EOF]
