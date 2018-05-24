function [NL, PrevIPorts, PrevOPorts, mainparams]=latticearmafootconnect(q,NL,H,mainparams);
%LATTICEARMAFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%add quantization blocks
NL.setnode(filtgraph.node('cast'),7);
set(NL.nodes(7).block,'label','CastState');
set(NL.nodes(7),'position',[0.9 1 0.9 1]);
set(NL.nodes(7).block,'orientation','left');
mainparams(7)=filtgraph.indexparam(7,{});

NL.setnode(filtgraph.node('convertio'),8);
set(NL.nodes(8).block,'label','ConvertIn');
set(NL.nodes(8),'position',[-0.25 0 -0.25 0]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});

% specify the qparam
%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(7),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.LatticeProdFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);

%Ladder Gain
laddergainqparam.qcoeff=[H.CoeffWordLength H.LadderFracLength];
laddergainqparam.qproduct=[H.ProductWordLength H.LadderProdFracLength];
laddergainqparam.Signed=H.Signed;
laddergainqparam.RoundMode=H.RoundMode;
laddergainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', laddergainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
end

%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(5),'qparam',inputqparam);
end

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(8),'qparam',convertinqparam);

%connection
NL.connect(2,1,1,2);
NL.connect(3,1,2,1);
NL.connect(5,1,8,1);
NL.connect(7,1,3,1);
NL.connect(7,1,4,1);
NL.connect(8,1,6,1);
NL.connect(6,1,1,1);
PrevIPorts = [filtgraph.nodeport(7,1)];
PrevOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(4,1)];
