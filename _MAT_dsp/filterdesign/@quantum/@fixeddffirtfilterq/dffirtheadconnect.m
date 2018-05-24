function [NL, NextIPorts, NextOPorts, mainparams]=dffirtheadconnect(q,NL,H,mainparams)
%DFFIRTHEADCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% add quantization blocks
NL.setnode(filtgraph.node('convertio'),5);
set(NL.nodes(5).block,'label','ConvertIn');
set(NL.nodes(5),'position',[0.5 0 0.5 0]);
set(NL.nodes(5).block,'orientation','right');
mainparams(5)=filtgraph.indexparam(5,{});

NL.setnode(filtgraph.node('convertio'),6);
set(NL.nodes(6).block,'label','ConvertOut');
set(NL.nodes(6),'position',[2.7 0 2.7 0]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

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
set(NL.nodes(2),'qparam', lgainqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',convertoutqparam);

s=getbestprecision(H);
%LHS
lsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
lsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(3),'qparam',lsumqparam);

%making connections
NL.connect(1,1,5,1);
NL.connect(5,1,2,1);
NL.connect(2,1,3,1);
NL.connect(3,1,6,1);
NL.connect(6,1,4,1);
NextIPorts=[filtgraph.nodeport(3,2)];
NextOPorts=[filtgraph.nodeport(5,1)];

