function this = latticereport(datatype,in,out,state,prod,acc)
%LATTICEREPORT   Construct a LATTICEREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.latticereport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.States = state;
this.Product = prod;
this.Accumulator = acc;

% [EOF]
