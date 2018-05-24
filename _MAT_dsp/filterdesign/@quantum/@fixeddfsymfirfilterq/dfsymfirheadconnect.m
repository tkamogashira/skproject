function [NL, NextIPorts, NextOPorts, mainparams]=dfsymfirheadconnect(q,NL,H,mainparams)
%DFSYMFIRHEADCONNECT specifies connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%Add quantization block
NL.setnode(filtgraph.node('convertio'),5);
set(NL.nodes(5).block,'label','ConvertIn');
set(NL.nodes(5),'position',[0.5 0 0.5 0]);
set(NL.nodes(5).block,'orientation','right');
mainparams(5)=filtgraph.indexparam(5,{});

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
set(NL.nodes(5),'qparam',convertinqparam);

%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', lgainqparam);

s=getbestprecision(H);
%LHS
lsumqparam.AccQ = [s.TapSumWordLength s.TapSumFracLength];
lsumqparam.sumQ = [H.TapSumWordLength H.TapSumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(2),'qparam',lsumqparam);

% setup the interstage connections

NL.setnode(filtgraph.node('convert'),6);
%RHS,CBS type convert
set(NL.nodes(6).block,'label','CBS');
set(NL.nodes(6),'position',[4 0 4 0]);
set(NL.nodes(6).block,'orientation','down');
mainparams(6) = filtgraph.indexparam(6,{});
convertapqparam.outQ=[H.AccumWordLength H.AccumFracLength];
convertapqparam.RoundMode=H.RoundMode;
convertapqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',convertapqparam);
%making connections
NL.connect(1,1,5,1);
NL.connect(5,1,2,1);
NL.connect(2,1,3,1);
NL.connect(3,1,6,1);
NL.connect(4,1,2,2);
NextIPorts=[filtgraph.nodeport(4,1)];
NextOPorts=[filtgraph.nodeport(5,1) filtgraph.nodeport(6,1)];
