function [NL, NextIPorts, NextOPorts, mainparams]=df1headconnect(q,NL,H,mainparams)
%DF1HEADCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% add quantization blocks
NL.setnode(filtgraph.node('convertio'),6);
set(NL.nodes(6).block,'label','ConvertIn');
set(NL.nodes(6),'position',[0.3 0 0.3 0]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('convertio'),2);
set(NL.nodes(2).block,'label','ConvertOut');
set(NL.nodes(2),'position',[4 0 4 0]);
set(NL.nodes(2).block,'orientation','right');
mainparams(2)=filtgraph.indexparam(2,{'0'},mainparams(2).gainlabels);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(3),'qparam',inputqparam);
end

%ConvertOut
castqparam.outQ=[H.OutputWordLength H.OutputFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam',castqparam);

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(6),'qparam',convertinqparam);

% gain
%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam', lgainqparam);

%connection and setup interstage connection
if H.CastBeforeSum
    NL.connect(3,1,6,1);
    NL.connect(6,1,1,1);
    NL.connect(2,1,4,1);
    NextIPorts=[filtgraph.nodeport(5,1) filtgraph.nodeport(2,1)];
    NextOPorts=[filtgraph.nodeport(6,1) filtgraph.nodeport(1,1) filtgraph.nodeport(5,1) filtgraph.nodeport(2,1)];
else
    %NumSum, convert
    NL.setnode(filtgraph.node('convert'),7);
    set(NL.nodes(7).block,'label','Convert');
    set(NL.nodes(7),'position',[2 0.5 2 0.5]);
    set(NL.nodes(7).block,'orientation','down');
    mainparams(7) = filtgraph.indexparam(7,{});
    convertqparam.outQ=[H.AccumWordLength H.NumAccumFracLength];
    convertqparam.RoundMode=H.RoundMode;
    convertqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(7),'qparam',convertqparam);
     %making connections
    NL.connect(3,1,6,1);
    NL.connect(6,1,1,1);
    NL.connect(1,1,7,1);
    NL.connect(2,1,4,1);
    NextIPorts=[filtgraph.nodeport(5,1) filtgraph.nodeport(2,1)];
    NextOPorts=[filtgraph.nodeport(6,1) filtgraph.nodeport(7,1) filtgraph.nodeport(5,1) filtgraph.nodeport(2,1)];
end
