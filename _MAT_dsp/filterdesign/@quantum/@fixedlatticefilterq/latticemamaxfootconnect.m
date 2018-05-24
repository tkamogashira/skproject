function [NL, PrevIPorts, PrevOPorts, mainparams]=latticemamaxfootconnect(q,NL,H,mainparams);
%LATTICEMAMAXFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% add quantization blocks
NL.setnode(filtgraph.node('convertio'),6);
set(NL.nodes(6).block,'label','ConvertOut');
set(NL.nodes(6),'position',[1.25 1 1.25 1]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

NL.setnode(filtgraph.node('cast'),7);
set(NL.nodes(7).block,'label','CastState');
set(NL.nodes(7),'position',[0.1 1 0.1 1]);
set(NL.nodes(7).block,'orientation','right');
mainparams(7)=filtgraph.indexparam(7,{});

NL.setnode(filtgraph.node('cast'),8);
set(NL.nodes(8).block,'label','CastInProd');
set(NL.nodes(8),'position',[0.4 0.7 0.4 0.7]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});

% specify the qparam
%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',convertoutqparam);

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

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
end

%connection
NL.connect(2,1,1,1);
NL.connect(3,1,1,2);
NL.connect(1,1,5,1);   
NL.connect(5,1,6,1);
NL.connect(6,1,4,1);
NL.connect(8,1,2,1);
NL.connect(7,1,3,1);
PrevIPorts = [filtgraph.nodeport(8,1) filtgraph.nodeport(7,1)];
PrevOPorts = [];

