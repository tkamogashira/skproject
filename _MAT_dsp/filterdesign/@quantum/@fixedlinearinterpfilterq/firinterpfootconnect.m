function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firinterpfootconnect(q,NL,H,mainparams,interp_order)

% Copyright 2005 The MathWorks, Inc.

hlocfactor = 1/(interp_order+1);
vlocfactor = 1/(2*interp_order+1);

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

for m=1:interp_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
    sumidx = interp_order+m;
    set(NL.nodes(sumidx),'qparam',sumqparam);
end

% connections
% connect gains to sum, note the last two gains connects to the same sum
% block (last one)
delayidx = 2*interp_order+1;
for m=1:interp_order
    gainidx = m;
    sumidx = interp_order + m;
    NL.connect(gainidx,1,sumidx,1);
    NL.connect(delayidx,1,gainidx,1);
end

% the port to previous and next stage
PrevOPorts=[];
NextIPorts=[];
PrevIPorts=[filtgraph.nodeport(delayidx,1)];
NextOPorts=[];
for m=1:interp_order
    sumidx = interp_order+m;
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(sumidx,2)];
    NextOPorts = [NextOPorts, filtgraph.nodeport(sumidx,1)];
end
