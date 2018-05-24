function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=df2bodyconnect(q,NL,H,mainparams)
%DF2BODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% gain
%Numerator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', rgainqparam);
%Denominator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);

if H.CastBeforeSum
    rsumqparam.AccQ = [H.AccumWordLength H.NumAccumFracLength];
    lsumqparam.AccQ = [H.AccumWordLength H.DenAccumFracLength];
else
    s=getbestprecision(H);
    rsumqparam.AccQ = [s.AccumWordLength s.NumAccumFracLength];
    lsumqparam.AccQ = [s.AccumWordLength s.DenAccumFracLength];
end

%Numerator sum
rsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(5),'qparam',rsumqparam);
%Denominator sum
lsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(1),'qparam',lsumqparam);


%connection and setup interstage connection
NL.connect(2,1,1,2);
NL.connect(3,1,2,1);
NL.connect(3,1,4,1);
NL.connect(4,1,5,1);
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1) filtgraph.nodeport(5,2)];
PrevOPorts = [filtgraph.nodeport(6,1)];
NextIPorts = [filtgraph.nodeport(6,1)];
NextOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1) filtgraph.nodeport(5,1)];

