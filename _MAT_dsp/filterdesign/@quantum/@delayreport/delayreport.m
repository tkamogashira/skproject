function this = delayreport(datatype,in,out)
%DELAYREPORT   Construct a DELAYREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.delayreport;
this.DataType = datatype;
this.Input = in;
this.Output = out;

% [EOF]
