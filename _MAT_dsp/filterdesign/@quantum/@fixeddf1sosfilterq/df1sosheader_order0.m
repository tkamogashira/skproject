function Head = df1sosheader_order0(q,sosMatrix,scaleValues,H,info)
%DF1SOSHEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage

%   Author(s): Honglei Chen
%   Copyright 1988-2009 The MathWorks, Inc.


% --------------------------------------------------------------
%
% head: Generate the conceptual header stage for Direct Form II SOS architecture
%
%   Returns a filtgraph.stage,
% --------------------------------------------------------------


% Construct the first layer, structure specific
NL=filtgraph.nodelist(18);

NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('gain'),3);
NL.setnode(filtgraph.node('sum'),4);
NL.setnode(filtgraph.node('sum'),5);
NL.setnode(filtgraph.node('sum'),6);
NL.setnode(filtgraph.node('sum'),7);
NL.setnode(filtgraph.node('gain'),8);
NL.setnode(filtgraph.node('output'),9);
NL.setnode(filtgraph.node('delay'),10);
NL.setnode(filtgraph.node('gain'),11);
NL.setnode(filtgraph.node('gain'),12);
NL.setnode(filtgraph.node('delay'),13);
NL.setnode(filtgraph.node('delay'),14);
NL.setnode(filtgraph.node('gain'),15);
NL.setnode(filtgraph.node('gain'),16);
NL.setnode(filtgraph.node('delay'),17);
NL.setnode(filtgraph.node('gain'),18);

% specify the block label

set(NL.nodes(1).block,'label','Input');
set(NL.nodes(2).block,'label','s');
set(NL.nodes(3).block,'label','b(1)');
set(NL.nodes(4).block,'label','SumB2');
set(NL.nodes(5).block,'label','SumB3');
set(NL.nodes(6).block,'label','SumA2');
set(NL.nodes(7).block,'label','SumA3');
set(NL.nodes(8).block,'label','1|a(1)');
set(NL.nodes(9).block,'label','Output');
set(NL.nodes(10).block,'label','B2Delay');
set(NL.nodes(11).block,'label','b(2)');
set(NL.nodes(12).block,'label','a(2)');
set(NL.nodes(13).block,'label','A2Delay');
set(NL.nodes(14).block,'label','B3Delay');
set(NL.nodes(15).block,'label','b(3)');
set(NL.nodes(16).block,'label','a(3)');
set(NL.nodes(17).block,'label','A3Delay');
set(NL.nodes(18).block,'label',['s' num2str(info.nstages+1)]);

% position defined as (x1,y1,x2,y2) with respect to NW and SW corner of the
% block.  Here we only define the center of the block.  Therefore here
% x1=x2 and y1=y2.  The real position is calculated when the simulink model
% is rendered.  The corresponding block size will be added to the center
% point. x is positive towards right and y is positive towards bottom
% specify the relative position towards the grid
set(NL.nodes(1),'position',[0 0 0 0]);
set(NL.nodes(2),'position',[1 0 1 0]);
set(NL.nodes(3),'position',[2 0 2 0]);
set(NL.nodes(4),'position',[3 0 3 0]);
set(NL.nodes(5),'position',[4 0 4 0]);
set(NL.nodes(6),'position',[5 0 5 0]);
set(NL.nodes(7),'position',[6 0 6 0]);
set(NL.nodes(8),'position',[7 0 7 0]);
set(NL.nodes(9),'position',[9 0 9 0]);
set(NL.nodes(10),'position',[1.5 0.2 1.5 0.2]);
set(NL.nodes(11),'position',[2.2 0.4 2.2 0.4]);
set(NL.nodes(12),'position',[6.8 0.4 6.8 0.4]);
set(NL.nodes(13),'position',[7.5 0.2 7.5 0.2]);
set(NL.nodes(14),'position',[1.5 0.6 1.5 0.6]);
set(NL.nodes(15),'position',[2.4 0.8 2.4 0.8]);
set(NL.nodes(16),'position',[6.6 0.8 6.6 0.8]);
set(NL.nodes(17),'position',[7.5 0.6 7.5 0.6]);
set(NL.nodes(18),'position',[8 0 8 0]);

% specify the orientation
for m=1:18
    switch m
        case {12,16}
            set(NL.nodes(m).block,'orientation','left');
        case {10,13,14,17}
            set(NL.nodes(m).block,'orientation','down');
        otherwise
            set(NL.nodes(m).block,'orientation','right');
    end
end

% specify coefficient names when mapcoeffstoports is on
label = cell(1,18);
if info.doMapCoeffsToPorts
    num_lbl = info.coeffnames{1};
    den_lbl = info.coeffnames{2};
    g_lbl = info.coeffnames{3};
    for m=1:18
        switch m
            case 8
                label{8} = sprintf('%s%d%d',den_lbl,1,1);
            case 3
                label{3} = sprintf('%s%d%d',num_lbl,1,1);
            case 12
                label{12} = sprintf('%s%d%d',den_lbl,2,1);
            case 11
                label{11} = sprintf('%s%d%d',num_lbl,2,1);
            case 2
                label{2} = sprintf('%s%d',g_lbl,info.nstages);
            case 16
                label{16} = sprintf('%s%d%d',den_lbl,3,1);
            case 15
                label{15} = sprintf('%s%d%d',num_lbl,3,1);
            case 18
                label{18} = sprintf('%s%d',g_lbl,length(scaleValues));
        end
    end
end

% Obtain the correct value for the gain block
num = sosMatrix(info.nstages,1:3);
den = sosMatrix(info.nstages,4:6);

% Obtain state information. The header_order0 contains only 2 rows of the
% state information. The columns of states represent channels.
numstates = info.states.Num;
denstates = info.states.Den;

% store the useful information into blocks
mainparams(18)=filtgraph.indexparam(18,{});
for m=1:18
    switch m
        case 8
            dg = num2str(1/den(1),'%22.18g');
            mainparams(m)=filtgraph.indexparam(m,dg,label{8});
        case 3
            ng = NL.coeff2str(num,1);
            mainparams(m)=filtgraph.indexparam(m,ng,label{3});
        case {6,7}
            mainparams(m)=filtgraph.indexparam(m,'|+-');
        case 12
            dg = NL.coeff2str(den,2);
            mainparams(m)=filtgraph.indexparam(m,dg,label{12});
        case 10
            delay_str = ['1,' mat2str(numstates(1,:))];
            mainparams(m)=filtgraph.indexparam(m,delay_str);
        case 14
            delay_str = ['1,' mat2str(numstates(2,:))];
            mainparams(m)=filtgraph.indexparam(m,delay_str);
        case 13
            delay_str = ['1,' mat2str(denstates(1,:))];
            mainparams(m)=filtgraph.indexparam(m,delay_str);
        case 17
            delay_str = ['1,' mat2str(denstates(2,:))];
            mainparams(m)=filtgraph.indexparam(m,delay_str);
        case 11
            ng = NL.coeff2str(num,2);
            mainparams(m)=filtgraph.indexparam(m,ng,label{11});
        case {4,5}
            mainparams(m)=filtgraph.indexparam(m,'|++');
        case 2
            sg = NL.coeff2str(scaleValues,info.nstages);
            if strcmpi(sg,'1') && H.OptimizeScaleValues
                sg = 'opsv';
            end
           mainparams(m)=filtgraph.indexparam(m,sg,label{2});
        case 16
            dg = NL.coeff2str(den,3);
            mainparams(m)=filtgraph.indexparam(m,dg,label{16});
        case 15
            ng = NL.coeff2str(num,3);
            mainparams(m)=filtgraph.indexparam(m,ng,label{15});
        case 18
            sg = NL.coeff2str(scaleValues,length(scaleValues));
            if strcmpi(sg,'1') && H.OptimizeScaleValues
                sg = 'opsv';
            end
            mainparams(m)=filtgraph.indexparam(m,sg,label{18});
        otherwise
            mainparams(m)=filtgraph.indexparam(m,{});
    end
end

% add quantization blocks
%replace a(1) with cast since a(1)=1 in fixed point
NL.setnode(filtgraph.node('cast'),8);
set(NL.nodes(8).block,'label','CastStates');
set(NL.nodes(8),'position',[7 0 7 0]);
set(NL.nodes(8).block,'orientation','right');
% Store the gain label so that we know that this node is an optimized
% gain. We need this to track and remove the useless gain labels from
% demux when MapCoeffsToPorts is on.
mainparams(8)=filtgraph.indexparam(8,{'0'},mainparams(8).gainlabels);

NL.setnode(filtgraph.node('convertio'),19);
set(NL.nodes(19).block,'label','ConvertIn');
set(NL.nodes(19),'position',[0.5 0 0.5 0]);
set(NL.nodes(19).block,'orientation','right');
mainparams(19)=filtgraph.indexparam(19,{});

% specify the qparam
%CastStates
castqparam.outQ=[H.DenStateWordLength H.DenStateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(8),'qparam',castqparam);

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
set(NL.nodes(19),'qparam',convertinqparam);

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
% if the scale value is 1, only a convert block is necessary since 1 does
% not to be quantized.
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
lscalegainqparam.qcoeff=[H.CoeffWordLength H.ScaleValueFracLength];
lscalegainqparam.qproduct=[H.OutputWordLength H.OutputFracLength];
lscalegainqparam.Signed=H.Signed;
lscalegainqparam.RoundMode=H.RoundMode;
lscalegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(18),'qparam', lscalegainqparam);

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
    set(NL.nodes(18),'position',[8 0 8 0]);
    % Store the gain label so that we know that this node is an optimized
    % gain. We need this to track and remove the useless gain labels from
    % demux when MapCoeffsToPorts is on.
    mainparams(18) = filtgraph.indexparam(18,{'0'},mainparams(18).gainlabels);
    set(NL.nodes(18),'qparam',convertoutqparam);
    NL.connect(18,1,9,1);
elseif strcmpi(mainparams(18).params,'1')
    NL.setnode(filtgraph.node('cast'),20);
    set(NL.nodes(20).block,'label','ConvertOut');
    set(NL.nodes(20).block,'orientation','right');
    set(NL.nodes(20),'position',[8.5 0 8.5 0]);
    mainparams(20) = filtgraph.indexparam(20,{});
    set(NL.nodes(20),'qparam',convertoutqparam);
    NL.connect(18,1,20,1);
    NL.connect(20,1,9,1);
else
    NL.connect(18,1,9,1);
end

NLlen = length(NL);

%connection
if H.CastBeforeSum
    NL.connect(4,1,5,1);
    NL.connect(5,1,6,1);
    NL.connect(6,1,7,1);
    NL.connect(7,1,8,1);
else
    %NumSum,ConvertAP type convert
    NL.setnode(filtgraph.node('convert'),NLlen+1);
    set(NL.nodes(NLlen+1).block,'label','CastSB2');
    set(NL.nodes(NLlen+1),'position',[3.5 0 3.5 0]);
    set(NL.nodes(NLlen+1).block,'orientation','right');
    mainparams(NLlen+1) = filtgraph.indexparam(NLlen+1,{});
    NL.setnode(filtgraph.node('convert'),NLlen+2);
    set(NL.nodes(NLlen+2).block,'label','CastSB3');
    set(NL.nodes(NLlen+2),'position',[4.5 0 4.5 0 ]);
    set(NL.nodes(NLlen+2).block,'orientation','right');
    mainparams(NLlen+2) = filtgraph.indexparam(NLlen+2,{});
    convertapqparam.outQ=[H.AccumWordLength H.NumAccumFracLength];
    convertapqparam.RoundMode=H.RoundMode;
    convertapqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(NLlen+1),'qparam',convertapqparam);
    set(NL.nodes(NLlen+2),'qparam',convertapqparam);
    %DenSum,Convert
    NL.setnode(filtgraph.node('convert'),NLlen+3);
    set(NL.nodes(NLlen+3).block,'label','CastSA2');
    set(NL.nodes(NLlen+3),'position',[5.5 0 5.5 0]);
    set(NL.nodes(NLlen+3).block,'orientation','right');
    mainparams(NLlen+3) = filtgraph.indexparam(NLlen+3,{});
    NL.setnode(filtgraph.node('convert'),NLlen+4);
    set(NL.nodes(NLlen+4).block,'label','CastSA3');
    set(NL.nodes(NLlen+4),'position',[6.5 0 6.5 0]);
    set(NL.nodes(NLlen+4).block,'orientation','right');
    mainparams(NLlen+4) = filtgraph.indexparam(NLlen+4,{});
    convertqparam.outQ=[H.AccumWordLength H.DenAccumFracLength];
    convertqparam.RoundMode=H.RoundMode;
    convertqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(NLlen+3),'qparam',convertqparam);
    set(NL.nodes(NLlen+4),'qparam',convertqparam);
    %making connections
    NL.connect(4,1,NLlen+1,1);
    NL.connect(NLlen+1,1,5,1);
    NL.connect(5,1,NLlen+2,1);
    NL.connect(NLlen+2,1,6,1);
    NL.connect(6,1,NLlen+3,1);
    NL.connect(NLlen+3,1,7,1);
    NL.connect(7,1,NLlen+4,1);
    NL.connect(NLlen+4,1,8,1);
end
NL.connect(1,1,19,1);
NL.connect(19,1,2,1);
NL.connect(2,1,3,1);
NL.connect(3,1,4,1);
NL.connect(8,1,18,1);
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

% Generate the stage.
Head = filtgraph.stage(NL,[],[],[],[],mainparams);
