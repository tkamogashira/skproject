function [NL, PrevIPorts, PrevOPorts, mainparams]=firdecimoutputconnect(q,NL,H,mainparams,decim_order)

%FIRDECIMOUTPUTCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual output stage

%   Author(s): Honglei Chen
%   Copyright 1988-2005 The MathWorks, Inc.

% add convert out block
NL.setnode(filtgraph.node('convertio'),2);
set(NL.nodes(2).block,'label','ConvertOut');
set(NL.nodes(2),'position',[0.2 0.5 0.2 0.5]);
set(NL.nodes(2).block,'orientation','right');
mainparams(2)=filtgraph.indexparam(2,{});

convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam',convertoutqparam);

% connection

NL.connect(2,1,1,1);

% specify the inter-stage connection
% nodeport(node, port)
% since head represents the first layer, no previous input and previous
% output ports
PrevIPorts=[filtgraph.nodeport(2,1)];
PrevOPorts=[];



