function this = df1treport(datatype,in,out,numstates,denstates,multiplicand,numprod,denprod,numacc,denacc)
%DF1TREPORT   Construct a DF1TREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(10,10,nargin,'struct'));

this = quantum.df1treport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.Multiplicand = multiplicand;
this.NumStates = numstates;
this.DenStates = denstates;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;

% [EOF]

% [EOF]
