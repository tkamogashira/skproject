function [NL, NextIPorts, NextOPorts, mainparams]=df2headconnect(q,NL,H,mainparams)
%DF2HEADCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% add quantization blocks
NL.setnode(filtgraph.node('convertio'),4);
set(NL.nodes(4).block,'label','ConvertIn');
set(NL.nodes(4),'position',[0.3 0.2 0.3 0.2]);
set(NL.nodes(4).block,'orientation','right');
mainparams(4)=filtgraph.indexparam(4,{});

%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('cast'),1);
set(NL.nodes(1).block,'label','CastStates');
set(NL.nodes(1),'position',[2 0 2 0]);
set(NL.nodes(1).block,'orientation','right');
mainparams(1)=filtgraph.indexparam(1,{'0'},mainparams(1).gainlabels);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(3),'qparam',inputqparam);
end

%CastStates
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam',castqparam);

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(4),'qparam',convertinqparam);

% gain
%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);

%connection
if H.CastBeforeSum
    % specify the connection
    % NL.connect(source node, source port, dest node, dest port)
    % note that input and output are numbered separately
    NL.connect(1,1,2,1);
    NL.connect(3,1,4,1);
    % specify the inter-stage connection
    % nodeport(node, port)
    % since head represents the first layer, no previous input and previous
    % output ports
    NextIPorts=[filtgraph.nodeport(1,1)];
    NextOPorts=[filtgraph.nodeport(4,1) filtgraph.nodeport(1,1) filtgraph.nodeport(2,1)];
else
    %Add a convert block before DenAcc
    NL.setnode(filtgraph.node('convert'),5);
    set(NL.nodes(5).block,'label','CovertH');
    set(NL.nodes(5),'position',[1 0.5 1 0.5]);
    set(NL.nodes(5).block,'orientation','down');
    mainparams(5) = filtgraph.indexparam(5,{});
    convertqparam.outQ=[H.AccumWordLength H.DenAccumFracLength];
    convertqparam.RoundMode=H.RoundMode;
    convertqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(5),'qparam',convertqparam);
    %Add a convert block before NumAcc
    NL.setnode(filtgraph.node('convert'),6);
    set(NL.nodes(6).block,'label','CovertF');
    set(NL.nodes(6),'position',[3.5 0 3.5 0]);
    set(NL.nodes(6).block,'orientation','right');
    mainparams(6) = filtgraph.indexparam(6,{});
    convertqparam.outQ=[H.AccumWordLength H.NumAccumFracLength];
    convertqparam.RoundMode=H.RoundMode;
    convertqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(6),'qparam',convertqparam);
    %making connections
    % specify the connection
    % NL.connect(source node, source port, dest node, dest port)
    % note that input and output are numbered separately
    NL.connect(1,1,2,1);
    NL.connect(2,1,6,1);
    NL.connect(3,1,4,1);
    NL.connect(4,1,5,1);
    % specify the inter-stage connection
    % nodeport(node, port)
    % since head represents the first layer, no previous input and previous
    % output ports
    NextIPorts=[filtgraph.nodeport(1,1)];
    NextOPorts=[filtgraph.nodeport(5,1) filtgraph.nodeport(1,1) filtgraph.nodeport(6,1)];
end
