function this = cicinterpreport(datatype,in,out,intlog,comblog)
%CICINTERPREPORT   Construct a CICINTERPREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(5,5,nargin,'struct'));

this = quantum.cicinterpreport;

this.DataType = datatype;
this.Input = in;
this.Output = out;

this.nsections = length(intlog);
createdynprop(this, datatype, intlog, comblog);


    
% [EOF]
