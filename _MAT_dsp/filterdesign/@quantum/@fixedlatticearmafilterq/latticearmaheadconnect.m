function [NL, NextIPorts, NextOPorts, mainparams] = latticearmaheadconnect(q,NL,H,mainparams)
%LATTICEARMAHEADCONNECT specifies connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


%add quantization blocks
NL.setnode(filtgraph.node('cast'),9);
set(NL.nodes(9).block,'label','CastInProd');
set(NL.nodes(9),'position',[0.6 0.7 0.6 0.7]);
set(NL.nodes(9).block,'orientation','left');
mainparams(9)=filtgraph.indexparam(9,{});

NL.setnode(filtgraph.node('cast'),10);
set(NL.nodes(10).block,'label','CastState');
set(NL.nodes(10),'position',[0.9 1 0.9 1]);
set(NL.nodes(10).block,'orientation','left');
mainparams(10)=filtgraph.indexparam(10,{});

NL.setnode(filtgraph.node('convertio'),11);
set(NL.nodes(11).block,'label','ConvertOut');
set(NL.nodes(11),'position',[1.7 1.5 1.7 1.5]);
set(NL.nodes(11).block,'orientation','right');
mainparams(11)=filtgraph.indexparam(11,{});

% specify the qparam
%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',castqparam);
set(NL.nodes(10),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.LatticeProdFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);
set(NL.nodes(3),'qparam', latticegainqparam);

%Ladder Gain
laddergainqparam.qcoeff=[H.CoeffWordLength H.LadderFracLength];
laddergainqparam.qproduct=[H.ProductWordLength H.LadderProdFracLength];
laddergainqparam.Signed=H.Signed;
laddergainqparam.RoundMode=H.RoundMode;
laddergainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam', laddergainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
    %Ladder sum
    laddersumqparam.AccQ = [H.AccumWordLength H.LadderAccumFracLength];
    laddersumqparam.sumQ = [H.AccumWordLength H.LadderAccumFracLength];
    laddersumqparam.RoundMode = H.RoundMode;
    laddersumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(7),'qparam',laddersumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
    laddersumqparam.AccQ = [s.AccumWordLength s.LadderAccumFracLength];
    laddersumqparam.sumQ = [H.AccumWordLength H.LadderAccumFracLength];
    laddersumqparam.RoundMode = H.RoundMode;
    laddersumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(7),'qparam',laddersumqparam);
end

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(11),'qparam',convertoutqparam);

%connection
NL.connect(1,1,9,1);
NL.connect(9,1,3,1);
NL.connect(1,1,10,1);
NL.connect(10,1,5,1);
NL.connect(10,1,6,1);
NL.connect(2,1,1,2);
NL.connect(3,1,4,1);
NL.connect(5,1,2,1);
NL.connect(5,1,4,2);
NL.connect(6,1,7,1);
NL.connect(7,1,11,1);
NL.connect(11,1,8,1);
NextIPorts=[filtgraph.nodeport(1,1) filtgraph.nodeport(7,2)];
NextOPorts=filtgraph.nodeport(4,1);

