function [y,z,Tnext] = farrowsrcfilter(this,C,x,L,M,z,Tnext)
%FARROWSRCFILTER Filter implementation for fixed point MFILT.FARROWSRC

%   Copyright 2007 The MathWorks, Inc.

x = quantizeinput(this,x);
Lx = length(x);

    function updatestates(x)
        % Update the states for each scalar input x.
        z = [x;z(1:end-1,:)];
    end
y = [];

fdWL = this.FDWordLength;
fdFL = this.FDFracLength;

% Define constants
S = getfdcomputefxpt(this,L,M);
gain = fi(1/L,0,S.WL.Gain,S.FL.Gain); 

for k = 1:Lx,   
    while Tnext > 0,
        d = fi(gain*Tnext,0,fdWL,fdFL,'RoundMode',this.fdfimath.RoundMode);
        y = [y;farrowfdfilter(this,C,x(k,:),d,z)];
        Tnext = Tnext-M; % Full precision integer math
    end   
    Tnext = Tnext+L;
    updatestates(x(k,:)); 
end
end 

% [EOF]
