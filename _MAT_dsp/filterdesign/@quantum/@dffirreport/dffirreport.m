function this = dffirreport(datatype,in,out,prod,acc)
%DFFIRREPORT   Construct a DFFIRREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));
this = quantum.dffirreport;
parse_inputs(this,datatype,in,out,prod,acc);

% [EOF]
