function [y, zf] = secfilter(Hm,x,zi)
% SECFILTER Polyphase FIR Transposed decimator filter
%  [Y,Zf] = SECFILTER(Hm,X,Zi)

%   Copyright 1999-2013 The MathWorks, Inc.

% Get the decimation factor
M = Hm.DecimationFactor;

% Get the polyphase filter
p = Hm.privpolym;

% States are not well supported when coefficients are complex and
% arithmetic is double or single. 
if ~isreal(p) && Hm.PersistentMemory && ~strcmp(Hm.Arithmetic,'fixed')
    error(message('dsp:mfilt:firtdecim:secfilter:UnsupportedPersistentMemory'));
end

% Get PolyphaseAccum
polyacc = Hm.PolyphaseAccum;

nchan = Hm.nchannels;

if ~(isempty(polyacc) || any(size(polyacc,2) == [nchan,1])),
	error(message('dsp:mfilt:firtdecim:secfilter:InvalidDimensions'));
end

% Expand polyacc for multiple channels
if size(polyacc,2)==1,
    polyacc = polyacc(:,ones(1,nchan));
end

[nx, nchans] = size(x);
ny = allocate(Hm,nx,Hm.InputOffset);
% [PhaseIndex InputOffset]
% [0          0          ]
% [1          M-1        ]
% [2          M-2        ]
% ...
% [M-1        1          ]
phaseidx = mod(M-mod(Hm.InputOffset,M),M);

% Call filter quantizer method
[y, zf, polyacc, phaseidx] = firtdecimfilter(Hm.filterquantizer,int32(M),p,x,zi,polyacc,int32(phaseidx),nx,nchans,ny);

% Store partial sums
Hm.PolyphaseAccum = polyacc;

% Transform phaseidx back into input offset
Hm.InputOffset = mod(M-mod(phaseidx,M),M);

