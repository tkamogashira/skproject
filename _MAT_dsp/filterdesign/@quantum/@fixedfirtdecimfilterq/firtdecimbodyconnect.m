function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firtdecimbodyconnect(q,NL,H,mainparams,decim_order)

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
    gainidx = decim_order+m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
    sumidx = 2*decim_order+m;
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
castidx = 3*decim_order+2;
NL.setnode(filtgraph.node('cast'),castidx);
set(NL.nodes(castidx).block,'label','BodyCast');
set(NL.nodes(castidx),'position',[0.25 1+locfactor 0.25 1+locfactor]);
set(NL.nodes(castidx).block,'orientation','right');
mainparams(castidx) = filtgraph.indexparam(castidx,{});
set(NL.nodes(castidx),'qparam',castqparam);



% connections
% connect connectors to gains
for m=1:decim_order
    gainidx = decim_order+m;
    NL.connect(m,1,gainidx,1);
end

% connect gains to sum, note the last two gains connects to the same sum
% block (last one)
for m=1:decim_order-1
    gainidx = decim_order+m;
    sumidx = 2*decim_order+m;
    NL.connect(gainidx,1,sumidx,1);
    if m < decim_order-1
        NL.connect(sumidx+1,1,sumidx,2);
    end
end
NL.connect(gainidx+1,1,sumidx,2);

% connect extra gain and delay block and convert blocks
polyaccidx = 2*decim_order + 1;
accsumidx = 3*decim_order;
delayidx = 3*decim_order + 1;
castidx = 3*decim_order + 2;
NL.connect(polyaccidx,1,accsumidx,1);
NL.connect(delayidx,1,accsumidx,2);
NL.connect(castidx,1,delayidx,1);

% the port to previous and next stage
PrevOPorts=[];
NextIPorts=[];
PrevIPorts=[];
NextOPorts=[];
for m=1:decim_order
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(m,1)];
    NextOPorts = [NextOPorts, filtgraph.nodeport(m,1)];
end
PrevIPorts = [PrevIPorts,filtgraph.nodeport(castidx,1)];  %cast input
NextOPorts = [NextOPorts,filtgraph.nodeport(accsumidx,1)];  %sum output
