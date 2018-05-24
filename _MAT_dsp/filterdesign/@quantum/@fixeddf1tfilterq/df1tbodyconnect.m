function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=df1tbodyconnect(q,NL,H,mainparams)
%DF1TBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% add quantization blocks

NL.setnode(filtgraph.node('cast'),9);
set(NL.nodes(9).block,'label','CastDenStates');
set(NL.nodes(9),'position',[1 -0.5 1 -0.5]);
set(NL.nodes(9).block,'orientation','up');
mainparams(9)=filtgraph.indexparam(9,{});

NL.setnode(filtgraph.node('cast'),10);
set(NL.nodes(10).block,'label','CastNumStates');
set(NL.nodes(10),'position',[4 -0.5 4 -0.5]);
set(NL.nodes(10).block,'orientation','up');
mainparams(10)=filtgraph.indexparam(10,{});

%specify qparam
%CastDenStates
castdenqparam.outQ=[H.StateWordLength H.DenStateFracLength];
castdenqparam.RoundMode=H.RoundMode;
castdenqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',castdenqparam);

%CastNumStates
castnumqparam.outQ=[H.StateWordLength H.NumStateFracLength];
castnumqparam.RoundMode=H.RoundMode;
castnumqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(10),'qparam',castnumqparam);

%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', lgainqparam);
%Denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', rgainqparam);

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
NL.connect(2,1,9,1);
NL.connect(9,1,1,1);
NL.connect(3,1,2,2);
NL.connect(4,1,5,1);
NL.connect(5,1,10,1);
NL.connect(10,1,6,1);
NL.connect(7,1,3,1);
NL.connect(8,1,4,1);


% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
PrevIPorts = [filtgraph.nodeport(7,1) filtgraph.nodeport(8,1)];
PrevOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(6,1)];
NextIPorts = [filtgraph.nodeport(2,1) filtgraph.nodeport(5,2)];
NextOPorts = [filtgraph.nodeport(7,1) filtgraph.nodeport(8,1)];
