function this = holdinterpreport(datatype,in,out)
%HOLDINTERPREPORT   Construct a HOLDINTERPREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.holdinterpreport;
this.DataType = datatype;
this.Input = in;
this.Output = out;

% [EOF]
