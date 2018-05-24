function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firtdecimfootconnect(q,NL,H,mainparams,decim_order)

% Copyright 2005 The MathWorks, Inc.

locfactor = 1/(decim_order+1);

% Specify qparams

%sum and gain
gainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;

s=getbestprecision(H);
polysumqparam.AccQ = [s.PolyAccWordLength s.PolyAccFracLength];
polysumqparam.sumQ = [H.PolyAccWordLength H.PolyAccFracLength];
polysumqparam.RoundMode = H.RoundMode;
polysumqparam.OverflowMode = H.OverflowMode;

accsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
accsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
accsumqparam.RoundMode = H.RoundMode;
accsumqparam.OverflowMode = H.OverflowMode;

for m=1:decim_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
    sumidx = decim_order+m;
    if m < decim_order
        set(NL.nodes(sumidx),'qparam',polysumqparam);
    else
        set(NL.nodes(sumidx),'qparam',accsumqparam);  %the extra sum is an accumulator
    end
end

% add state convert block
castqparam.outQ = [H.StateWordLength H.StateFracLength];
castqparam.RoundMode = H.RoundMode;
castqparam.OverflowMode = H.OverflowMode;
castidx = 2*decim_order + 2;
NL.setnode(filtgraph.node('cast'),castidx);
set(NL.nodes(castidx).block,'label','FootCast');
set(NL.nodes(castidx),'position',[0.25 1+locfactor 0.25 1+locfactor]);
set(NL.nodes(castidx).block,'orientation','right');
mainparams(castidx) = filtgraph.indexparam(castidx,{});
set(NL.nodes(castidx),'qparam',castqparam);

% connections

% connect gains to sum, note the last two gains connects to the same sum
% block (last one)
for m=1:decim_order-1
    gainidx = m;
    sumidx = decim_order+m;
    NL.connect(gainidx,1,sumidx,1);
    if m < decim_order-1
        NL.connect(sumidx+1,1,sumidx,2);
    end
end
NL.connect(gainidx+1,1,sumidx,2);

% connect extra gain and delay block
polyaccidx = decim_order+1;
accsumidx = 2*decim_order;
delayidx = 2*decim_order + 1;
castidx = 2*decim_order + 2;
NL.connect(polyaccidx,1,accsumidx,1);
NL.connect(delayidx,1,accsumidx,2);
NL.connect(castidx,1,delayidx,1);

% the port to previous and next stage
PrevOPorts=[];
NextIPorts=[];
PrevIPorts=[];
for m=1:decim_order
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(m,1)];
end
PrevIPorts = [PrevIPorts,filtgraph.nodeport(castidx,1)];  %cast input
NextOPorts = [filtgraph.nodeport(accsumidx,1)];  %sum output
