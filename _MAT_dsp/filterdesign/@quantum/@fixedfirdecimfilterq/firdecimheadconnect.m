function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=firdecimheadconnect(q,NL,H,mainparams,decim_order)

% Copyright 2005 The MathWorks, Inc.


vlocfactor = 1/(4*decim_order+1);   % to fit everything into one grid.  The grid is enlarged using gridGrowingFactor
vlocoffset = 4*vlocfactor;

% Specify qparams

%sum
s=getbestprecision(H);
sumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
sumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
sumqparam.RoundMode = H.RoundMode;
sumqparam.OverflowMode = H.OverflowMode;
for m=1:decim_order-1
    sumidx = 2*decim_order+m;
    set(NL.nodes(sumidx),'qparam',sumqparam);
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
    set(NL.nodes(convertinidx),'position',[0 (m-1)*vlocoffset 0 (m-1)*vlocoffset]);
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
end

% the port to previous and next stage
PrevOPorts=[];
NextIPorts=[];
PrevIPorts=[];
NextOPorts=[];
for m=1:decim_order
    convertinidx = m;
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(convertinidx,1)];
    sumidx = 2*decim_order + m;
    gainidx = decim_order + m;
    if m < decim_order
        NextOPorts = [NextOPorts, filtgraph.nodeport(convertinidx,1), filtgraph.nodeport(sumidx,1)];
        NextIPorts = [NextIPorts, filtgraph.nodeport(sumidx,2)];
    else
        NextOPorts = [NextOPorts, filtgraph.nodeport(m,1), filtgraph.nodeport(gainidx,1)];
    end
end
