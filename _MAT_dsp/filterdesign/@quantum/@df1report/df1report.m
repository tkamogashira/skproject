function this = df1report(datatype,in,out,numprod,denprod,numacc,denacc)
%DF1REPORT   Construct a DF1REPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(7,7,nargin,'struct'));

this = quantum.df1report;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;

% [EOF]
