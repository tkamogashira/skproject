function this = linearinterpreport(datatype,in,out,prod,acc)
%LINEARINTERPREPORT   Construct a LINEARINTERPREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));
this = quantum.linearinterpreport;
parse_inputs(this,datatype,in,out,prod,acc);

% [EOF]
