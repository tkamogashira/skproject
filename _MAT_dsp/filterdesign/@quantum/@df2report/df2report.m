function this = df2report(datatype,in,out,states,numprod,denprod,numacc,denacc)
%DF2REPORT   Construct a DF2REPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(8,8,nargin,'struct'));

this = quantum.df2report;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.States = states;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;

% [EOF]
