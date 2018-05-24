function [y, z] = secfilter(Hm,x,z)
% SECFILTER Polyphase FIR Interpolator filter
%  [Y,Zf] = SECFILTER(Hm,X,Zi)
  
%   Author:
%   Copyright 1999-2005 The MathWorks, Inc.

% Get the interpolation factor
L = Hm.InterpolationFactor;

% Get the polyphase filters
p = Hm.privpolym;

[nx nchans] = size(x);
ny = L*nx;

tapidx = Hm.TapIndex;

% Call filter quantizer method
[y,z,tapidx] = firinterpfilter(Hm.filterquantizer, ...
    uint32(L),p.',x,z,tapidx,nx,nchans,ny);

Hm.TapIndex = tapidx;

