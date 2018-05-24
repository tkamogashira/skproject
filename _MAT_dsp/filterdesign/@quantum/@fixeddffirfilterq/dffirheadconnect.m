function [NL, NextIPorts, NextOPorts, mainparams]=dffirheadconnect(q,NL,H,mainparams)
%DFFIRHEADCONNECT specifies connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%Add quantizatio blocks
NL.setnode(filtgraph.node('convertio'),3);
set(NL.nodes(3).block,'label','ConvertIn');
set(NL.nodes(3),'position',[0.5 0 0.5 0]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3)=filtgraph.indexparam(3,{});


% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(1),'qparam',inputqparam);
end

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(3),'qparam',convertinqparam);

%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);

% specify the connection
% NL.connect(source node, source port, dest node, dest port)
% note that input and output are numbered separately
NL.connect(1,1,3,1);
NL.connect(3,1,2,1);

% specify the inter-stage connection
% nodeport(node, port)
% since head represents the first layer, no previous input and previous
% output ports
%LHS,ConvertAP type convert
NL.setnode(filtgraph.node('convert'),4);
set(NL.nodes(4).block,'label','Convert');
set(NL.nodes(4),'position',[2 0.5 2 0.5]);
set(NL.nodes(4).block,'orientation','down');
mainparams(4) = filtgraph.indexparam(4,{});
convertapqparam.outQ=[H.AccumWordLength H.AccumFracLength];
convertapqparam.RoundMode=H.RoundMode;
convertapqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam',convertapqparam);
%making connections
NL.connect(2,1,4,1);
NextIPorts=[];
NextOPorts=[filtgraph.nodeport(3,1) filtgraph.nodeport(4,1)];
