function [NL, NextIPorts, NextOPorts, mainparams]=df2theadconnect(q,NL,H,mainparams)
%DF2THEADCONNECT specifies connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


%Add quantizatio block
NL.setnode(filtgraph.node('convertio'),6);
set(NL.nodes(6).block,'label','ConvertIn');
set(NL.nodes(6),'position',[0.5 0 0.5 0]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

%replace a(1) with convert block since a(1)=1 in fixed point mode
NL.setnode(filtgraph.node('convertio'),4);
set(NL.nodes(4).block,'label','CastCAS');
set(NL.nodes(4),'position',[3.5 0 3.5 0]);
set(NL.nodes(4).block,'orientation','right');
mainparams(4)=filtgraph.indexparam(4,{'0'},mainparams(4).gainlabels);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(1),'qparam',inputqparam);
end
%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(6),'qparam',convertinqparam);
%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam',convertoutqparam);

% gain
%LHG
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);
% LHS sum
if H.CastBeforeSum
    lsumqparam.AccQ = [H.AccumWordLength H.NumAccumFracLength];
else
    s=getbestprecision(H);
    lsumqparam.AccQ = [s.AccumWordLength s.NumAccumFracLength];
end
lsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(3),'qparam',lsumqparam);


% specify the connection
% NL.connect(source node, source port, dest node, dest port)
% note that input and output are numbered separately
NL.connect(1,1,6,1);
NL.connect(6,1,2,1);
NL.connect(2,1,3,1);
NL.connect(4,1,5,1);

% specify the inter-stage connection
% nodeport(node, port)
% since head represents the first layer, no previous input and previous
% output ports
NL.connect(3,1,4,1);
NextIPorts=[filtgraph.nodeport(3,2)];
NextOPorts=[filtgraph.nodeport(6,1) filtgraph.nodeport(4,1)];

