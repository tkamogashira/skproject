function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=dfasymfirbodyconnect(q,NL,H,mainparams)
%DFASYMFIRBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', lgainqparam);

s=getbestprecision(H);
%LHS
lsumqparam.AccQ = [s.TapSumWordLength s.TapSumFracLength];
lsumqparam.sumQ = [H.TapSumWordLength H.TapSumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',lsumqparam);
%RHS
rsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
rsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(5),'qparam',rsumqparam);

%making connections
NL.connect(1,1,2,1);
NL.connect(2,1,3,1);
NL.connect(4,1,2,2);
NL.connect(3,1,5,1);
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(5,2)];
PrevOPorts = [filtgraph.nodeport(4,1)];
NextIPorts = [filtgraph.nodeport(4,1)];
NextOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(5,1)];

