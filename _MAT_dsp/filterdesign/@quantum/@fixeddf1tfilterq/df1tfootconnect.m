function [NL, PrevIPorts, PrevOPorts, mainparams]=df1tfootconnect(q,NL,H,mainparams);
%DF1TFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% add quantization blocks

NL.setnode(filtgraph.node('cast'),5);
set(NL.nodes(5).block,'label','CastDenStates');
set(NL.nodes(5),'position',[1 -0.5 1 -0.5]);
set(NL.nodes(5).block,'orientation','up');
mainparams(5)=filtgraph.indexparam(5,{});

NL.setnode(filtgraph.node('cast'),6);
set(NL.nodes(6).block,'label','CastNumStates');
set(NL.nodes(6),'position',[4 -0.5 4 -0.5]);
set(NL.nodes(6).block,'orientation','up');
mainparams(6)=filtgraph.indexparam(6,{});

%specify qparam
%CastDenStates
castdenqparam.outQ=[H.StateWordLength H.DenStateFracLength];
castdenqparam.RoundMode=H.RoundMode;
castdenqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',castdenqparam);

%CastNumStates
castnumqparam.outQ=[H.StateWordLength H.NumStateFracLength];
castnumqparam.RoundMode=H.RoundMode;
castnumqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',castnumqparam);

%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', lgainqparam);
%Denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', rgainqparam);

NL.connect(2,1,5,1);
NL.connect(5,1,1,1);
NL.connect(3,1,6,1);
NL.connect(6,1,4,1);

% specify the interstage connection
% last layer, therefore no next input and output 
PrevIPorts = [filtgraph.nodeport(2,1) filtgraph.nodeport(3,1)];
PrevOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(4,1)];
