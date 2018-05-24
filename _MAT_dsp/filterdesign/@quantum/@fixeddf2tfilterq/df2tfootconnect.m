function [NL, PrevIPorts, PrevOPorts, mainparams]=df2tfootconnect(q,NL,H,mainparams);
%DF2TFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL.setnode(filtgraph.node('cast'),5);
set(NL.nodes(5).block,'label','CastStates');
set(NL.nodes(5),'position',[2 -0.6 2 -0.6]);
set(NL.nodes(5).block,'orientation','up');
mainparams(5)=filtgraph.indexparam(5,{});

%CastStates
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',castqparam);

% note that left sum and right sum hold different quantization parameters.
% Also if H.CastBeforeSum is true, need to consider more things.
if H.CastBeforeSum
    rsumqparam.AccQ = [H.AccumWordLength H.DenAccumFracLength];
else
    s=getbestprecision(H);
    rsumqparam.AccQ = [s.AccumWordLength s.DenAccumFracLength];
end
%RHS denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',rsumqparam);


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
set(NL.nodes(3),'qparam', rgainqparam);

NL.connect(1,1,2,1);
NL.connect(3,1,2,2);
NL.connect(5,1,4,1);

% specify the interstage connection
% last layer, therefore no next input and output
NL.connect(2,1,5,1);
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1)];
PrevOPorts = [filtgraph.nodeport(4,1)];


