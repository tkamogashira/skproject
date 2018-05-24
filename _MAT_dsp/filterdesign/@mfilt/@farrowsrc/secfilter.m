function [y,z] = secfilter(this,x,z)
%SECFILTER

%   Copyright 2007 The MathWorks, Inc.

L = this.InterpolationFactor;
M = this.DecimationFactor;
C = this.privcoeffs;
C = C.';
Tnext = this.Tnext;
[y,z,Tnext] = farrowsrcfilter(this.filterquantizer,C,x,L,M,z,Tnext);
this.Tnext = Tnext;

% [EOF]
