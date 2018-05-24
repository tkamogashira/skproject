function [NL, PrevIPorts, PrevOPorts, mainparams]=latticeallpassfootconnect(q,NL,H,mainparams);
%LATTICEALLPASSFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% add quantization blocks
NL.setnode(filtgraph.node('convertio'),8);
set(NL.nodes(8).block,'label','ConvertIn');
set(NL.nodes(8),'position',[-0.25 0 -0.25 0]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});


NL.setnode(filtgraph.node('convertio'),9);
set(NL.nodes(9).block,'label','ConvertOut');
set(NL.nodes(9),'position',[-0.25 1 -0.25 1]);
set(NL.nodes(9).block,'orientation','left');
mainparams(9)=filtgraph.indexparam(9,{});

NL.setnode(filtgraph.node('cast'),10);
set(NL.nodes(10).block,'label','CastInProd');
set(NL.nodes(10),'position',[0.6 0.7 0.6 0.7]);
set(NL.nodes(10).block,'orientation','left');
mainparams(10)=filtgraph.indexparam(10,{});

NL.setnode(filtgraph.node('cast'),11);
set(NL.nodes(11).block,'label','CastState');
set(NL.nodes(11),'position',[0.9 1 0.9 1]);
set(NL.nodes(11).block,'orientation','left');
mainparams(11)=filtgraph.indexparam(11,{});

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(6),'qparam',inputqparam);
end

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(8),'qparam',convertinqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',convertoutqparam);

%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(10),'qparam',castqparam);
set(NL.nodes(11),'qparam',castqparam);

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

%connection
NL.connect(1,1,10,1);
NL.connect(2,1,1,2);
NL.connect(3,1,4,1);
NL.connect(4,1,9,1);
NL.connect(5,1,2,1);
NL.connect(5,1,4,2);
NL.connect(6,1,8,1);
NL.connect(8,1,1,1);
NL.connect(9,1,7,1);
NL.connect(10,1,3,1);
NL.connect(11,1,5,1);
PrevIPorts = [filtgraph.nodeport(11,1)];
PrevOPorts = [filtgraph.nodeport(1,1)];


