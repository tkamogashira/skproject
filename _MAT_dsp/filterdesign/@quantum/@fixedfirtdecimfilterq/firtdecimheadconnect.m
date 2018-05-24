function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firtdecimheadconnect(q,NL,H,mainparams,decim_order)

% Copyright 2005 The MathWorks, Inc.

locfactor = 1/(decim_order+1);

% Specify qparams

%sum
% These sums are polyphase accumulators
s=getbestprecision(H);
polysumqparam.AccQ = [s.PolyAccWordLength s.PolyAccFracLength];
polysumqparam.sumQ = [H.PolyAccWordLength H.PolyAccFracLength];
polysumqparam.RoundMode = H.RoundMode;
polysumqparam.OverflowMode = H.OverflowMode;
for m=1:decim_order-1
    sumidx = 2*decim_order+m;
    set(NL.nodes(sumidx),'qparam',polysumqparam);
end

%gain
gainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;
for m=1:decim_order
    gainidx = decim_order+m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
end

%replace all connector blocks to converio block
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
for m=1:decim_order
    convertinidx=m;
    NL.setnode(filtgraph.node('convertio'),convertinidx);
    set(NL.nodes(convertinidx).block,'label',['ConvertIn' num2str(m)]);
    set(NL.nodes(convertinidx),'position',[0 locfactor*(m-1) 0 locfactor*(m-1)]);
    set(NL.nodes(convertinidx).block,'orientation','right');
    mainparams(convertinidx) = filtgraph.indexparam(convertinidx,{});
    set(NL.nodes(convertinidx),'qparam',convertinqparam);
end

% connections
% connect connectors to gains
for m=1:decim_order
    convertinidx = m;
    gainidx = decim_order+m;
    NL.connect(convertinidx,1,gainidx,1);
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

% the port to previous and next stage
PrevOPorts=[];
NextIPorts=[];
PrevIPorts=[];
NextOPorts=[];
for m=1:decim_order
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(m,1)];
    NextOPorts = [NextOPorts, filtgraph.nodeport(m,1)];
end
sumidx = 2*decim_order+1;
NextOPorts = [NextOPorts,filtgraph.nodeport(sumidx,1)];  %sum output
