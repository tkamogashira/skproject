function [NL, NextIPorts, NextOPorts, mainparams]=df1sosheadconnect(q,NL,H,mainparams)
%DF1SOSHEADCONNECT specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2008 The MathWorks, Inc.


% add quantization blocks
NL.setnode(filtgraph.node('convertio'),18);
set(NL.nodes(18).block,'label','ConvertIn');
set(NL.nodes(18),'position',[0.5 0 0.5 0]);
set(NL.nodes(18).block,'orientation','right');
mainparams(18)=filtgraph.indexparam(18,{});

%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('cast'),8);
set(NL.nodes(8).block,'label','CastStates');
set(NL.nodes(8),'position',[7 0 7 0]);
set(NL.nodes(8).block,'orientation','right');
% Store the gain label so that we know that this node is an optimized
% gain. We need this to track and remove the useless gain labels from
% demux when MapCoeffsToPorts is on.
mainparams(8)=filtgraph.indexparam(8,{'0'},mainparams(8).gainlabels);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(1),'qparam',inputqparam);
end

%CastStates
castqparam.outQ=[H.DenStateWordLength H.DenStateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(8),'qparam',castqparam);

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(18),'qparam',convertinqparam);

% gain
%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', lgainqparam);
set(NL.nodes(11),'qparam', lgainqparam);
set(NL.nodes(15),'qparam', lgainqparam);
%Denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(12),'qparam', rgainqparam);
set(NL.nodes(16),'qparam', rgainqparam);
%Scale Gain
% if the scale value is 1 and OptimizeScaleValues is true, only a convert
% block is necessary since 1 does not to be quantized.
if strcmpi(mainparams(2).params,'opsv')
    NL.setnode(filtgraph.node('cast'),2);
    set(NL.nodes(2).block,'label','ConvertScale');
    set(NL.nodes(2).block,'orientation','right');
    set(NL.nodes(2),'position',[1 0 1 0]);
    % Store the gain label so that we know that this node is an optimized
    % gain. We need this to track and remove the useless gain labels from
    % demux when MapCoeffsToPorts is on.
    mainparams(2)=filtgraph.indexparam(2,{'0'},mainparams(2).gainlabels);
    %ConvertScale
    convertscaleqparam.outQ=[H.NumStateWordLength H.NumStateFracLength];
    convertscaleqparam.RoundMode=H.RoundMode;
    convertscaleqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(2),'qparam',convertscaleqparam);
else
    scalegainqparam.qcoeff=[H.CoeffWordLength H.ScaleValueFracLength];
    scalegainqparam.qproduct=[H.NumStateWordLength H.NumStateFracLength];
    scalegainqparam.Signed=H.Signed;
    scalegainqparam.RoundMode=H.RoundMode;
    scalegainqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(2),'qparam', scalegainqparam);
end

if H.CastBeforeSum
    lsumqparam.AccQ = [H.AccumWordLength H.NumAccumFracLength];
    rsumqparam.AccQ = [H.AccumWordLength H.DenAccumFracLength];
else
    s=getbestprecision(H);
    lsumqparam.AccQ = [s.AccumWordLength s.NumAccumFracLength];
    rsumqparam.AccQ = [s.AccumWordLength s.DenAccumFracLength];
end
%Numerator sum
lsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(4),'qparam',lsumqparam);
set(NL.nodes(5),'qparam',lsumqparam);
%Denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(6),'qparam',rsumqparam);
set(NL.nodes(7),'qparam',rsumqparam);

%connection
if H.CastBeforeSum
    NL.connect(1,1,18,1);
    NL.connect(18,1,2,1);
    NL.connect(2,1,3,1);
    NL.connect(3,1,4,1);
    NL.connect(4,1,5,1);
    NL.connect(5,1,6,1);
    NL.connect(6,1,7,1);
    NL.connect(7,1,8,1);
    NL.connect(8,1,9,1);
    NL.connect(2,1,10,1);
    NL.connect(10,1,11,1);
    NL.connect(11,1,4,2);
    NL.connect(10,1,14,1);
    NL.connect(14,1,15,1);
    NL.connect(15,1,5,2);
    NL.connect(8,1,13,1);
    NL.connect(13,1,12,1);
    NL.connect(12,1,6,2);
    NL.connect(13,1,17,1);
    NL.connect(17,1,16,1);
    NL.connect(16,1,7,2);
else
    %NumSum,ConvertAP type convert
    NL.setnode(filtgraph.node('convert'),19);
    set(NL.nodes(19).block,'label','CastSB2');
    set(NL.nodes(19),'position',[3.5 0 3.5 0]);
    set(NL.nodes(19).block,'orientation','right');
    mainparams(19) = filtgraph.indexparam(19,{});
    NL.setnode(filtgraph.node('convert'),20);
    set(NL.nodes(20).block,'label','CastSB3');
    set(NL.nodes(20),'position',[4.5 0 4.5 0 ]);
    set(NL.nodes(20).block,'orientation','right');
    mainparams(20) = filtgraph.indexparam(20,{});
    convertapqparam.outQ=[H.AccumWordLength H.NumAccumFracLength];
    convertapqparam.RoundMode=H.RoundMode;
    convertapqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(19),'qparam',convertapqparam);
    set(NL.nodes(20),'qparam',convertapqparam);
    %DenSum,Convert
    NL.setnode(filtgraph.node('convert'),21);
    set(NL.nodes(21).block,'label','CastSA2');
    set(NL.nodes(21),'position',[5.5 0 5.5 0]);
    set(NL.nodes(21).block,'orientation','right');
    mainparams(21) = filtgraph.indexparam(21,{});
    NL.setnode(filtgraph.node('convert'),22);
    set(NL.nodes(22).block,'label','CastSA3');
    set(NL.nodes(22),'position',[6.5 0 6.5 0]);
    set(NL.nodes(22).block,'orientation','right');
    mainparams(22) = filtgraph.indexparam(22,{});
    convertqparam.outQ=[H.AccumWordLength H.DenAccumFracLength];
    convertqparam.RoundMode=H.RoundMode;
    convertqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(21),'qparam',convertqparam);
    set(NL.nodes(22),'qparam',convertqparam);
    %making connections
    NL.connect(1,1,18,1);
    NL.connect(18,1,2,1);
    NL.connect(2,1,3,1);
    NL.connect(3,1,4,1);
    NL.connect(4,1,19,1);
    NL.connect(19,1,5,1);
    NL.connect(5,1,20,1);
    NL.connect(20,1,6,1);
    NL.connect(6,1,21,1);
    NL.connect(21,1,7,1);
    NL.connect(7,1,22,1);
    NL.connect(22,1,8,1);
    NL.connect(8,1,9,1);
    NL.connect(2,1,10,1);
    NL.connect(10,1,11,1);
    NL.connect(11,1,4,2);
    NL.connect(10,1,14,1);
    NL.connect(14,1,15,1);
    NL.connect(15,1,5,2);
    NL.connect(8,1,13,1);
    NL.connect(13,1,12,1);
    NL.connect(12,1,6,2);
    NL.connect(13,1,17,1);
    NL.connect(17,1,16,1);
    NL.connect(16,1,7,2);
end

% specify the inter-stage connection
% nodeport(node, port)
% since head represents the first layer, no previous input and previous
% output ports
NextIPorts=[];
NextOPorts=[];
