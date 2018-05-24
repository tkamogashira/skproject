function [NL, PrevIPorts, PrevOPorts, mainparams]=df2footconnect(q,NL,H,mainparams);
%DF2FOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%add quantization blocks
NL.setnode(filtgraph.node('convertio'),7);
set(NL.nodes(7).block,'label','ConvertOut');
set(NL.nodes(7).block,'orientation','right');
set(NL.nodes(7),'position',[4.7 0 4.7 0]);
mainparams(7)=filtgraph.indexparam(7,{});

%specifies qparam
%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(7),'qparam',convertoutqparam);

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
NL.connect(4,1,5,2);
NL.connect(5,1,7,1);
NL.connect(7,1,6,1);
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1) filtgraph.nodeport(5,1)];
PrevOPorts = [filtgraph.nodeport(1,1)];

% specify the interstage connection
% last layer, therefore no next input and output
