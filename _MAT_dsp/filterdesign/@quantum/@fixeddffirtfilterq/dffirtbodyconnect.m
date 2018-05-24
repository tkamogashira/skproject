function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=dffirtbodyconnect(q,NL,H,mainparams)
%DFFIRTBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL.setnode(filtgraph.node('cast'),5);
set(NL.nodes(5).block,'label','ConvertState');
set(NL.nodes(5).block,'orientation','up');
set(NL.nodes(5),'position',[2 -0.5 2 -0.5]);
mainparams(5) = filtgraph.indexparam(5,{});

convertqparam.outQ=[H.StateWordLength H.StateFracLength];
convertqparam.RoundMode=H.RoundMode;
convertqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',convertqparam);

%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam', lgainqparam);

s=getbestprecision(H);
%LHS
lsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
lsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',lsumqparam);

%making connections
NL.connect(4,1,1,1);
NL.connect(1,1,2,1);
NL.connect(2,1,5,1);
NL.connect(5,1,3,1);
PrevIPorts = [filtgraph.nodeport(4,1)];
PrevOPorts = [filtgraph.nodeport(3,1)];
NextIPorts = [filtgraph.nodeport(2,2)];
NextOPorts = [filtgraph.nodeport(4,1)];

