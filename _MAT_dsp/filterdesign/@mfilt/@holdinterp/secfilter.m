function [y, z] = secfilter(Hm,x,z)
% SECFILTER Polyphase FIR Interpolator filter
%  [Y,Zf] = SECFILTER(Hm,X,Zi)
  
%   Author:
%   Copyright 1999-2005 The MathWorks, Inc.

% Get the interpolation factor
L = Hm.InterpolationFactor;
[nx nchans] = size(x);
ny = L*nx;

y = holdinterpfilter(Hm.filterquantizer,L,x,ny,nchans);


