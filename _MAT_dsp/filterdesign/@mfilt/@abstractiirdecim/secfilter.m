function [y, zf] = secfilter(this,x,zi)
%SECFILTER

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

M = this.DecimationFactor;
inputoffset = this.InputOffset;
polyaccum = this.PolyphaseAccum;

if isscalar(polyaccum),
    polyaccum = polyaccum*ones(1,size(x,2));
end

% Preallocate output
ny = allocate(this,size(x,1),inputoffset);
y  = zeros(ny,size(x,2));
outcount = 1;

% Pass along states to phase dfilts
stateoffset = 1;
for n = 1:M,
    phasenstates = nstates(this.privphase(n));
    reset(this.privphase(n)); % Reset the phase
    this.privphase(n).PersistentMemory = true;
    this.privphase(n).states = zi(stateoffset:stateoffset+phasenstates-1,:);
    stateoffset = stateoffset + phasenstates;
end

for k = 1:size(x,1),
    
    inputidx = inputoffset + k;

    n = mod(M-mod(inputidx - 1,M),M) + 1; % phaseindex

    polyaccum = polyaccum + filter(this.privphase(n),x(k,:),1);
    if n == 1,
        y(outcount,:) = 1/M*polyaccum;
        outcount = outcount  + 1;
        polyaccum = zeros(size(polyaccum));
    end
end

% Set final states
stateoffset = 1;
for p = 1:M,
    phasenstates = nstates(this.privphase(p));
    zf(stateoffset:stateoffset+phasenstates-1,:) = this.privphase(p).states;
    stateoffset = stateoffset + phasenstates;
end

% Store partial sums
this.PolyphaseAccum = polyaccum;

% Transform phaseidx back into input offset
this.InputOffset = mod(inputoffset+size(x,1),M);


% [EOF]
