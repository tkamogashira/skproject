function Head = firtdecimheader_order0(q,num,decim_order,H,info)

% Copyright 2005 The MathWorks, Inc.

% Construct the first layer, structure specific
NL=filtgraph.nodelist(2*decim_order-1);

locfactor = 1/(decim_order+1);

% Specify coefficient names
nglbl = cell(1,decim_order);
if info.doMapCoeffsToPorts
    for m=1:decim_order
        nglbl{m} = sprintf('%s%d',info.coeffnames{1},m);
    end
end

% connectors & gains
for m=1:decim_order
    %gain
    gainidx = m;   %calculate the node index in the node list
    NL.setnode(filtgraph.node('gain'),gainidx);
    set(NL.nodes(gainidx).block,'label',['headgain' num2str(m)]);
    set(NL.nodes(gainidx),'position',[1-locfactor*m locfactor*m 1-locfactor*m locfactor*m]);  %gain aligned backwards
    set(NL.nodes(gainidx).block,'orientation','down');
    ng = {'0'};
    ng = NL.coeff2str(num,m);
    mainparams(gainidx)=filtgraph.indexparam(gainidx,ng,nglbl{m});
end

% sums
for m=1:decim_order-1
    sumidx = decim_order + m;
    NL.setnode(filtgraph.node('sum'),sumidx);
    set(NL.nodes(sumidx).block,'label',['headsum' num2str(m)]);
    set(NL.nodes(sumidx),'position',[1-locfactor*m 1 1-locfactor*m 1]);
    set(NL.nodes(sumidx).block,'orientation','right');
    mainparams(sumidx)=filtgraph.indexparam(sumidx,'++|');
end

% Specify qparams

%sum
% These sums are polyphase accumulators
s=getbestprecision(H);
polysumqparam.AccQ = [s.PolyAccWordLength s.PolyAccFracLength];
polysumqparam.sumQ = [H.PolyAccWordLength H.PolyAccFracLength];
polysumqparam.RoundMode = H.RoundMode;
polysumqparam.OverflowMode = H.OverflowMode;
for m=1:decim_order-1
    sumidx = decim_order+m;
    set(NL.nodes(sumidx),'qparam',polysumqparam);
end

%gain
gainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;

for m=1:decim_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
end

%add converio block
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
for m=1:decim_order
    convertinidx=2*decim_order-1+m;
    NL.setnode(filtgraph.node('convertio'),convertinidx);
    set(NL.nodes(convertinidx).block,'label',['ConvertIn' num2str(m)]);
    set(NL.nodes(convertinidx),'position',[0 locfactor*(m-1) 0 locfactor*(m-1)]);
    set(NL.nodes(convertinidx).block,'orientation','right');
    mainparams(convertinidx) = filtgraph.indexparam(convertinidx,{});
    set(NL.nodes(convertinidx),'qparam',convertinqparam);
end


% connections

% connect gains to sum, note the last two gains connects to the same sum
% block (last one)
for m=1:decim_order
    gainidx = m;
    convertinidx = 2*decim_order-1+m;
    NL.connect(convertinidx,1,gainidx,1);
end
for m=1:decim_order-1
    gainidx = m;
    sumidx = decim_order+m;
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
for m=1:decim_order
    convertinidx = 2*decim_order-1+m;
    PrevIPorts = [PrevIPorts, filtgraph.nodeport(convertinidx,1)];
end
sumidx = decim_order+1;
NextOPorts = [filtgraph.nodeport(sumidx,1)];  %sum output


% Generate the stage.
Head = filtgraph.stage(NL,PrevIPorts,PrevOPorts,NextIPorts,NextOPorts,mainparams);
