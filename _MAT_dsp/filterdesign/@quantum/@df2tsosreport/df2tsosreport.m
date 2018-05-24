function this = df2tsosreport(datatype,in,out,sectin,sectout,states,numprod,denprod,numacc,denacc)
%DF2TSOSREPORT   Construct a DF2TSOSREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(10,10,nargin,'struct'));

this = quantum.df2tsosreport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.SectionIn = sectin;
this.SectionOut = sectout;
this.States = states;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;% [EOF]
