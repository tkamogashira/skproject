function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=df2tsosbodyconnect(q,NL,H,mainparams)
%DF2TSOSBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2008 The MathWorks, Inc.

%replace the gain with the output cast since in fixed point mode, a(1)=1
% specify the qparam
NL.setnode(filtgraph.node('cast'),5);
set(NL.nodes(5).block,'label','CastStageOutput');
set(NL.nodes(5).block,'orientation','right');
set(NL.nodes(5),'position',[5 0 5 0]);

NL.setnode(filtgraph.node('cast'),16);
NL.setnode(filtgraph.node('cast'),17);
set(NL.nodes(16).block,'label','CastStates');
set(NL.nodes(17).block,'label','CastFootStates');
set(NL.nodes(16),'position',[4 0.2 4 0.2]);
set(NL.nodes(17),'position',[3 0.6 3 0.6]);
set(NL.nodes(16).block,'orientation','up');
set(NL.nodes(17).block,'orientation','up');
mainparams(16)=filtgraph.indexparam(16,{});
mainparams(17)=filtgraph.indexparam(17,{});

% specify the qparam
%CastStageOutput
caststageoutqparam.outQ=[H.SectionOutputWordLength H.SectionOutputFracLength];
caststageoutqparam.RoundMode=H.RoundMode;
caststageoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',caststageoutqparam);

% gain
%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam', lgainqparam);
set(NL.nodes(7),'qparam', lgainqparam);
set(NL.nodes(12),'qparam', lgainqparam);
%RHG denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(10),'qparam', rgainqparam);
set(NL.nodes(14),'qparam', rgainqparam);
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
    convertscaleqparam.outQ=[H.SectionInputWordLength H.SectionInputFracLength];
    convertscaleqparam.RoundMode=H.RoundMode;
    convertscaleqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(2),'qparam',convertscaleqparam);
else
    scalegainqparam.qcoeff=[H.CoeffWordLength H.ScaleValueFracLength];
    scalegainqparam.qproduct=[H.SectionInputWordLength H.SectionInputFracLength];
    scalegainqparam.Signed=H.Signed;
    scalegainqparam.RoundMode=H.RoundMode;
    scalegainqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(2),'qparam', scalegainqparam);
end

%CastStates
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(16),'qparam',castqparam);
set(NL.nodes(17),'qparam',castqparam);


% sum
if H.CastBeforeSum
    lsumqparam.AccQ = [H.AccumWordLength H.NumAccumFracLength];
    rsumqparam.AccQ = [H.AccumWordLength H.DenAccumFracLength];
else
    s=getbestprecision(H);
    lsumqparam.AccQ = [s.AccumWordLength s.NumAccumFracLength];
    rsumqparam.AccQ = [s.AccumWordLength s.DenAccumFracLength];
end
%LHS numerator sum
lsumqparam.sumQ = [H.AccumWordLength H.NumAccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(4),'qparam',lsumqparam);
set(NL.nodes(8),'qparam',lsumqparam);
set(NL.nodes(13),'qparam',lsumqparam);
%RHS denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(9),'qparam',rsumqparam);


% specify the connection
% NL.connect(source node, source port, dest node, dest port)
% note that input and output are numbered separately
NL.connect(1,1,2,1);
NL.connect(2,1,3,1);
NL.connect(2,1,7,1);
NL.connect(2,1,12,1);
NL.connect(3,1,4,1);
NL.connect(5,1,6,1);
NL.connect(5,1,10,1);
NL.connect(5,1,14,1);
NL.connect(7,1,8,1);
NL.connect(10,1,9,2);
NL.connect(11,1,4,2);
NL.connect(12,1,13,1);
NL.connect(14,1,13,2);
NL.connect(15,1,8,2);
NL.connect(16,1,11,1);
NL.connect(17,1,15,1);

% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
NL.connect(4,1,5,1);
NL.connect(8,1,9,1);
NL.connect(9,1,16,1);
NL.connect(13,1,17,1);

PrevIPorts = [];
PrevOPorts = [];
NextIPorts = [];
NextOPorts = [];
