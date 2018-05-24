function [NL, PrevIPorts, PrevOPorts, mainparams]=df1tsosfootconnect(q,NL,H,mainparams)
%DF1TSOSFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2009 The MathWorks, Inc.

% add quantization blocks

NL.setnode(filtgraph.node('caststage'),19);
set(NL.nodes(19).block,'label','CastStageIn');
set(NL.nodes(19),'position',[0.5 0 0.5 0]);
set(NL.nodes(19).block,'orientation','right');
mainparams(19)=filtgraph.indexparam(19,{});

NL.setnode(filtgraph.node('caststage'),20);
set(NL.nodes(20).block,'label','CastStageOut');
set(NL.nodes(20),'position',[5.7 0 5.7 0]);
set(NL.nodes(20).block,'orientation','right');
mainparams(20)=filtgraph.indexparam(20,{});

%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('cast'),4);
set(NL.nodes(4).block,'label','CastMult');
set(NL.nodes(4),'position',[3 0 3 0]);
set(NL.nodes(4).block,'orientation','right');
% Store the gain label so that we know that this node is an optimized
% gain. We need this to track and remove the useless gain labels from
% demux when MapCoeffsToPorts is on.
mainparams(4)=filtgraph.indexparam(4,{'0'},mainparams(4).gainlabels);

NL.setnode(filtgraph.node('cast'),21);
set(NL.nodes(21).block,'label','CastDenStates2');
set(NL.nodes(21),'position',[2 0.2 2 0.2]);
set(NL.nodes(21).block,'orientation','up');
mainparams(21)=filtgraph.indexparam(21,{});

NL.setnode(filtgraph.node('cast'),22);
set(NL.nodes(22).block,'label','CastNumStates2');
set(NL.nodes(22),'position',[5 0.2 5 0.2]);
set(NL.nodes(22).block,'orientation','up');
mainparams(22)=filtgraph.indexparam(22,{});

NL.setnode(filtgraph.node('cast'),23);
set(NL.nodes(23).block,'label','CastDenStates3');
set(NL.nodes(23),'position',[2 0.7 2 0.7]);
set(NL.nodes(23).block,'orientation','up');
mainparams(23)=filtgraph.indexparam(23,{});

NL.setnode(filtgraph.node('cast'),24);
set(NL.nodes(24).block,'label','CastNumStates3');
set(NL.nodes(24),'position',[5 0.7 5 0.7]);
set(NL.nodes(24).block,'orientation','up');
mainparams(24)=filtgraph.indexparam(24,{});


% specify the qparam
%CastStates
castqparam.outQ=[H.MultiplicandWordLength H.MultiplicandFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam',castqparam);


%CastStageOutput
caststageoutqparam.outQ=[H.SectionOutputWordLength H.SectionOutputFracLength];
caststageoutqparam.RoundMode=H.RoundMode;
caststageoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(19),'qparam',caststageoutqparam);
set(NL.nodes(20),'qparam',caststageoutqparam);

% gain
%Numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam', lgainqparam);
set(NL.nodes(11),'qparam', lgainqparam);
set(NL.nodes(16),'qparam', lgainqparam);
%Denominator gain
rgainqparam.qcoeff=[H.CoeffWordLength H.DenFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.DenProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(10),'qparam', rgainqparam);
set(NL.nodes(15),'qparam', rgainqparam);
%Scale Gain
% in this case, if scale value is 1 and OptimizeScaleValues is true, will
% be removed together with preceding convert block by the remove_caststage
% function
scalegainqparam.qcoeff=[H.CoeffWordLength H.ScaleValueFracLength];
scalegainqparam.qproduct=[H.SectionInputWordLength H.SectionInputFracLength];
scalegainqparam.Signed=H.Signed;
scalegainqparam.RoundMode=H.RoundMode;
scalegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', scalegainqparam);
lscalegainqparam.qcoeff=[H.CoeffWordLength H.ScaleValueFracLength];
lscalegainqparam.qproduct=[H.OutputWordLength H.OutputFracLength];
lscalegainqparam.Signed=H.Signed;
lscalegainqparam.RoundMode=H.RoundMode;
lscalegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(18),'qparam', lscalegainqparam);

%CastDenStates
castdenqparam.outQ=[H.StateWordLength H.DenStateFracLength];
castdenqparam.RoundMode=H.RoundMode;
castdenqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(21),'qparam',castdenqparam);
set(NL.nodes(23),'qparam',castdenqparam);

%CastNumStates
castnumqparam.outQ=[H.StateWordLength H.NumStateFracLength];
castnumqparam.RoundMode=H.RoundMode;
castnumqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(22),'qparam',castnumqparam);
set(NL.nodes(24),'qparam',castnumqparam);

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
set(NL.nodes(6),'qparam',lsumqparam);
set(NL.nodes(12),'qparam',lsumqparam);
%Denominator sum
rsumqparam.sumQ = [H.AccumWordLength H.DenAccumFracLength];
rsumqparam.RoundMode = H.RoundMode;
rsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(3),'qparam',rsumqparam);
set(NL.nodes(9),'qparam',rsumqparam);


% If last scale value is 1 and OptimizeScaleValues is true, the parameter
% is 'opsv' and the block is replaced by a ConvertOut block. This block is
% of type 'convertio' as no future optimization is required. If last scale
% value is 1 and OptmizeScaleValues is false, the parameter is '1' and we
% need to render an additional ConvertOut block. This block is of type
% 'cast' as it may need to be optimized in the future. If OptimizeOnes is
% 'on' for realizemdl, the block will stay as it is responsible for cast
% the output to the right format. Otherwise, this block will be removed by
% optimize_noopconvert since it is an noop.

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
if strcmpi(mainparams(18).params,'opsv')
    NL.setnode(filtgraph.node('convertio'),18);
    set(NL.nodes(18).block,'label','ConvertOut');
    set(NL.nodes(18).block,'orientation','right');
    set(NL.nodes(18),'position',[6 0 6 0]);
    % Store the gain label so that we know that this node is an optimized
    % gain. We need this to track and remove the useless gain labels from
    % demux when MapCoeffsToPorts is on.
    mainparams(18) = filtgraph.indexparam(18,{'0'},mainparams(18).gainlabels);
    set(NL.nodes(18),'qparam',convertoutqparam);
    NL.connect(18,1,7,1);
elseif strcmpi(mainparams(18).params,'1')
    NL.setnode(filtgraph.node('cast'),25);
    set(NL.nodes(25).block,'label','ConvertOut');
    set(NL.nodes(25).block,'orientation','right');
    set(NL.nodes(25),'position',[6.5 0 6.5 0]);
    mainparams(25) = filtgraph.indexparam(25,{});
    set(NL.nodes(25),'qparam',convertoutqparam);
    NL.connect(18,1,25,1);
    NL.connect(25,1,7,1);
else
    NL.connect(18,1,7,1);
end

%connection
NL.connect(1,1,19,1);
NL.connect(2,1,3,1);
NL.connect(3,1,4,1);
NL.connect(4,1,5,1);
NL.connect(4,1,10,1);
NL.connect(4,1,11,1);
NL.connect(4,1,15,1);
NL.connect(4,1,16,1);
NL.connect(5,1,6,1);
NL.connect(6,1,20,1);
NL.connect(8,1,3,2);
NL.connect(9,1,21,1);
NL.connect(10,1,9,2);
NL.connect(11,1,12,1);
NL.connect(12,1,22,1);
NL.connect(13,1,6,2);
NL.connect(14,1,9,1);
NL.connect(15,1,23,1);
NL.connect(16,1,24,1);
NL.connect(17,1,12,2);
NL.connect(19,1,2,1);
NL.connect(20,1,18,1);
NL.connect(21,1,8,1);
NL.connect(22,1,13,1);
NL.connect(23,1,14,1);
NL.connect(24,1,17,1);

% specify the interstage connection
% last layer, therefore no next input and output
PrevIPorts = [];
PrevOPorts = [];
