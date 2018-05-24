function [NL, NextIPorts, NextOPorts, mainparams] = latticearheadconnect(q,NL,H,mainparams)
%LATTICEARHEADCONNECT specifies the connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.



%add quantization blocks
NL.setnode(filtgraph.node('cast'),7);
set(NL.nodes(7).block,'label','CastInProd');
set(NL.nodes(7),'position',[0.6 0.7 0.6 0.7]);
set(NL.nodes(7).block,'orientation','left');
mainparams(7)=filtgraph.indexparam(7,{});

NL.setnode(filtgraph.node('cast'),8);
set(NL.nodes(8).block,'label','CastState');
set(NL.nodes(8),'position',[0.9 1 0.9 1]);
set(NL.nodes(8).block,'orientation','left');
mainparams(8)=filtgraph.indexparam(8,{});

NL.setnode(filtgraph.node('convertio'),9);
set(NL.nodes(9).block,'label','ConvertOut');
set(NL.nodes(9),'position',[1.25 0 1.25 0]);
set(NL.nodes(9).block,'orientation','right');
mainparams(9)=filtgraph.indexparam(9,{});

% specify the qparam
%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(7),'qparam',castqparam);
set(NL.nodes(8),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);
set(NL.nodes(3),'qparam', latticegainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
end

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',convertoutqparam);

%connection
NL.connect(1,1,7,1);
NL.connect(1,1,8,1);
NL.connect(1,1,9,1);
NL.connect(2,1,1,2);
NL.connect(3,1,4,1);
NL.connect(5,1,2,1);
NL.connect(5,1,4,2);
NL.connect(7,1,3,1);
NL.connect(8,1,5,1);
NL.connect(9,1,6,1);
NextIPorts=[filtgraph.nodeport(1,1)];
NextOPorts=[filtgraph.nodeport(4,1)];

