function this = firtdecimreport(datatype,in,out,state,prod,acc,polyacc)
%FIRTDECIMREPORT   Construct a FIRTDECIMREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.firtdecimreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.States = state;
this.PolyAcc = polyacc;

% [EOF]
