function [y, zf] = secfilter(this,x,zi)
%SECFILTER   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

L = this.InterpolationFactor;

% Preallocate output
y = zeros(L*size(x,1),size(x,2));

% Pass along states to phase dfilts
stateoffset = 1;

for n = 1:length(this.privphase),
    phasenstates = nstates(this.privphase(n));
    reset(this.privphase(n)); % Reset the phase
    this.privphase(n).PersistentMemory = true;
    this.privphase(n).states = zi(stateoffset:stateoffset+phasenstates-1,:);
    
    if size(x,1) == 1,
        y(n:L:end,:) = filter(this.privphase(n),x,1);
    else
       y(n:L:end,:) = filter(this.privphase(n),x); 
    end
    
    zf(stateoffset:stateoffset+phasenstates-1,:) = this.privphase(n).states;
    stateoffset = stateoffset + phasenstates;
end
    

% [EOF]
