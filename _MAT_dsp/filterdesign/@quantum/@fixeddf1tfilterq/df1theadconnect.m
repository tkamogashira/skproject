function [NL, NextIPorts, NextOPorts, mainparams]=df1theadconnect(q,NL,H,mainparams)
%DF1THEADCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% add quantization blocks
NL.setnode(filtgraph.node('convertio'),7);
set(NL.nodes(7).block,'label','ConvertIn');
set(NL.nodes(7),'position',[0.5 0 0.5 0]);
set(NL.nodes(7).block,'orientation','right');
mainparams(7)=filtgraph.indexparam(7,{});

NL.setnode(filtgraph.node('convertio'),8);
set(NL.nodes(8).block,'label','ConvertOut');
set(NL.nodes(8),'position',[4.7 0 4.7 0]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});

%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('cast'),3);
set(NL.nodes(3).block,'label','CastMult');
set(NL.nodes(3),'position',[2 0 2 0]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3)=filtgraph.indexparam(3,{'0'},mainparams(3).gainlabels);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(1),'qparam',inputqparam);
end

%CastStates
castqparam.outQ=[H.MultiplicandWordLength H.MultiplicandFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam',castqparam);

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(7),'qparam',convertinqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(8),'qparam',convertoutqparam);

%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', lgainqparam);

% note that left sum and right sum hold different quantization parameters.
% Also if H.CastBeforeSum is true, need to consider more things.
if H.CastBeforeSum
    lsumqparam.AccQ = [H.AccumWordLength H.NumAccumFracLength];
    rsumqparam.AccQ = [H.AccumWordLength H.DenAccumFracLength];
else
    s=getbestprecision(H);
    lsumqparam.AccQ = [s.AccumWordLength s.NumAccumFracLength];
    rsumqparam.AccQ = [s.AccumWordLength s.DenAccumFracLength];
end
%Numerator sum
lsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(5),'qparam',lsumqparam);
%Denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',rsumqparam);

%connection
NL.connect(1,1,7,1);
NL.connect(7,1,2,1);
NL.connect(2,1,3,1);
NL.connect(3,1,4,1);
NL.connect(4,1,5,1);
NL.connect(5,1,8,1);
NL.connect(8,1,6,1);
NextIPorts=[filtgraph.nodeport(2,2) filtgraph.nodeport(5,2)];
NextOPorts=[filtgraph.nodeport(3,1) filtgraph.nodeport(3,1)];

