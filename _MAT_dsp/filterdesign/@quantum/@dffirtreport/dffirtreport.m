function this = dffirtreport(datatype,in,out,state,prod,acc)
%DFFIRTREPORT   Construct a DFFIRTREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.dffirtreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.States = state;

% [EOF]
