function this = df2treport(datatype,in,out,states,numprod,denprod,numacc,denacc)
%DF2TREPORT   Construct a DF2TREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(8,8,nargin,'struct'));

this = quantum.df2treport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.States = states;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;
