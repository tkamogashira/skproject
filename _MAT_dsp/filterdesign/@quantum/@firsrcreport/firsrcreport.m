function this = firsrcreport(datatype,in,out,prod,acc)
%FIRSRCREPORT   Construct a FIRSRCREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));
this = quantum.firsrcreport;
parse_inputs(this,datatype,in,out,prod,acc);

% [EOF]
