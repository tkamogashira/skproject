function this = scalarreport(datatype,in,out)
%SCALARREPORT   Construct a SCALARREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.scalarreport;
this.DataType = datatype;
this.Input = in;
this.Output = out;

% [EOF]
