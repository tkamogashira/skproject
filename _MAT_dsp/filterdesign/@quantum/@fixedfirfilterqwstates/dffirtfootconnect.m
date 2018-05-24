function [NL, PrevIPorts, PrevOPorts, mainparams]=dffirtfootconnect(q,NL,H,mainparams);
%DFFIRTFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL.setnode(filtgraph.node('cast'),3);
set(NL.nodes(3).block,'label','ConvertState');
set(NL.nodes(3).block,'orientation','up');
set(NL.nodes(3),'position',[2 -0.5 2 -0.5]);
mainparams(3) = filtgraph.indexparam(3,{});

convertqparam.outQ=[H.StateWordLength H.StateFracLength];
convertqparam.RoundMode=H.RoundMode;
convertqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam',convertqparam);

%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam', lgainqparam);

%make the connection
NL.connect(1,1,3,1);
NL.connect(3,1,2,1);

% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
PrevIPorts = [filtgraph.nodeport(1,1)];
PrevOPorts = [filtgraph.nodeport(2,1)];
