function this = cicdecimreport(datatype,in,out,intlog,comblog)
%CICDECIMREPORT   Construct a CICDECIMREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));

this = quantum.cicdecimreport;

this.DataType = datatype;
this.Input = in;
this.Output = out;

this.nsections = length(intlog);
createdynprop(this, datatype, intlog, comblog);

% [EOF]
