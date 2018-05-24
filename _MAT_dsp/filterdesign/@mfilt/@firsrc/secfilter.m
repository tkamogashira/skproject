function [y, z] = secfilter(Hm,x,z)
% SECFILTER Polyphase FIR sampling-rate converter filter.
%  [Y,Zf] = SECFILTER(Hm,X,Zi)
  
%   Author: R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1); M = R(2);

[Mx,Nx] = size(x);

% Get the polyphase filters
P = Hm.privpolym;
N = size(P,2);

% Determine output length
My = allocate(Hm,Mx,double(Hm.InputOffset));

tapidx = Hm.TapIndex;

% Call filter quantizer method
[y, z, tapidx] = firsrcfilter(Hm.filterquantizer, ...
    uint32(L),uint32(M),P.',x,z,tapidx,...
    Hm.PolyphaseSelector,Hm.InputOffset,Mx,Nx,My);


% Update input offset and tap index
Hm.InputOffset = mod(Hm.InputOffset+Mx,M); % This returns a uint32

Hm.TapIndex = tapidx;