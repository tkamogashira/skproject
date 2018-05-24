function [NL, PrevIPorts, PrevOPorts, mainparams]=firinterpoutputconnect(q,NL,H,mainparams,interp_order)

%FIRTINTERPOUTPUTCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual output stage

%   Author(s): Honglei Chen
%   Copyright 1988-2005 The MathWorks, Inc.

% add convert out block
NL.setnode(filtgraph.node('convertio'),3);
set(NL.nodes(3).block,'label','ConvertOut');
set(NL.nodes(3),'position',[0.8 0.5 0.8 0.5]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3)=filtgraph.indexparam(3,{});

convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam',convertoutqparam);

NL.connect(2,1,3,1);
NL.connect(3,1,1,1);

% specify the inter-stage connection
% nodeport(node, port)
% since head represents the first layer, no previous input and previous
% output ports
PrevIPorts=[];
for m=1:interp_order
    PrevIPorts = [PrevIPorts filtgraph.nodeport(2,m)];
end
PrevOPorts=[];



