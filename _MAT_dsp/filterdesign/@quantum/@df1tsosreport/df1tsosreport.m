function this = df1tsosreport(datatype,in,out,sectin,sectout,numstates,denstates,multiplicand,numprod,denprod,numacc,denacc)
%DF1TSOSREPORT   Construct a DF1TSOSREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(12,12,nargin,'struct'));

this = quantum.df1tsosreport;

this.DataType = datatype;
this.Input = in;
this.Output = out;
this.SectionIn = sectin;
this.SectionOut = sectout;
this.Multiplicand = multiplicand;
this.NumStates = numstates;
this.DenStates = denstates;
this.NumProd = numprod;
this.DenProd = denprod;
this.NumAcc = numacc;
this.DenAcc = denacc;

% [EOF]
