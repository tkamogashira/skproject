function this = firinterpreport(datatype,in,out,prod,acc)
%FIRINTERPREPORT   Construct a FIRINTERPREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));
this = quantum.firinterpreport;
parse_inputs(this,datatype,in,out,prod,acc);

% [EOF]
