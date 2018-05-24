function this = fdfarrowreport(datatype,in,out,prod,acc,mult,fdprod)
%FDFARROWREPORT   Construct a FDFARROWREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

this = quantum.fdfarrowreport;
parse_inputs(this,datatype,in,out,prod,acc);
this.Multiplicand = mult;
this.FDProduct = fdprod;

% [EOF]
