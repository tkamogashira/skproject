function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=df2tbodyconnect(q,NL,H,mainparams)
%DF2TBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL.setnode(filtgraph.node('cast'),8);
set(NL.nodes(8).block,'label','CastStates');
set(NL.nodes(8),'position',[2 -0.6 2 -0.6]);
set(NL.nodes(8).block,'orientation','up');
mainparams(8)=filtgraph.indexparam(8,{});

%CastStates
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(8),'qparam',castqparam);

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
%LHS numerator sum
lsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',lsumqparam);
%RHS denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(3),'qparam',rsumqparam);


%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam', lgainqparam);
%RHG denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', rgainqparam);

%make the connection
NL.connect(6,1,1,1);
NL.connect(1,1,2,1);
NL.connect(4,1,3,2);
NL.connect(7,1,4,1);
NL.connect(8,1,5,1);

% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
NL.connect(2,1,3,1);
NL.connect(3,1,8,1);
PrevIPorts = [filtgraph.nodeport(6,1) filtgraph.nodeport(7,1)];
PrevOPorts = [filtgraph.nodeport(5,1)];
NextIPorts = [filtgraph.nodeport(2,2)];
NextOPorts = [filtgraph.nodeport(6,1) filtgraph.nodeport(7,1)];




