function this = latticearmareport(datatype,in,out,states,latprod,latacc,ladprod,ladacc)
%LATTICEARMAREPORT   Construct a LATTICEARMAREPORT object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

error(nargchk(8,8,nargin,'struct'));

this = quantum.latticearmareport;
this.DataType = datatype;
this.Input = in;
this.Output = out;
this.States = states;
this.LatticeProd = latprod;
this.LatticeAcc = latacc;
this.LadderProd = ladprod;
this.LadderAcc = ladacc;

% [EOF]
