function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firdecimfootconnect(q,NL,H,mainparams,decim_order)

% Copyright 2005 The MathWorks, Inc.

vlocfactor = 1/(4*decim_order+1);   % to fit everything into one grid.  The grid is enlarged using gridGrowingFactor
vlocoffset = 4*vlocfactor;

% Specify qparams

%sum and gain
s=getbestprecision(H);
sumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
sumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
sumqparam.RoundMode = H.RoundMode;
sumqparam.OverflowMode = H.OverflowMode;

gainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;

for m=1:decim_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
    sumidx = decim_order+m;
    set(NL.nodes(sumidx),'qparam',sumqparam);
end

% connections
for m=1:decim_order
    % connect delay to gains
    gainidx = m;
    delayidx = 2*decim_order+m;
    NL.connect(delayidx,1,gainidx,1);
    %connect gain to sum
    sumidx = decim_order+m;
    NL.connect(gainidx,1,sumidx,1);
end

% the port to previous and next stage
NextIPorts=[];
PrevOPorts=[];
PrevIPorts=[];
for m=1:decim_order
    sumidx = decim_order + m;
    delayidx = 2*decim_order + m;
    if m == 1
        NextOPorts = [filtgraph.nodeport(sumidx,1)];
    else
        PrevOPorts = [PrevOPorts, filtgraph.nodeport(sumidx,1)];
    end
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(delayidx,1), filtgraph.nodeport(sumidx,2)];
end
