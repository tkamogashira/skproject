function this = df1sosreport(datatype,in,out,numstates,denstates,numprod,denprod,numacc,denacc)
%DF1SOSREPORT   Construct a DF1SOSREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(9,9,nargin,'struct'));

this = quantum.df1sosreport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.NumStates = numstates;
this.DenStates = denstates;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;

% [EOF]
