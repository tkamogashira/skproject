function this = firdecimreport(datatype,in,out,prod,acc)
%FIRDECIMREPORT   Construct a FIRDECIMREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));
this = quantum.firdecimreport;
parse_inputs(this,datatype,in,out,prod,acc);

% [EOF]
