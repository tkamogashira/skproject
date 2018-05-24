function Head = latticearmaheader_order0(q,num,den,H,info)
%LATTICEARMAHEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% Generate the last layer of the structure.

NL=filtgraph.nodelist(6);

NL.setnode(filtgraph.node('sum'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('delay'),3);
NL.setnode(filtgraph.node('gain'),4);


% specify the block label

set(NL.nodes(1).block,'label','BodyQSum');
set(NL.nodes(2).block,'label','K');
set(NL.nodes(3).block,'label','BodyDelay');
set(NL.nodes(4).block,'label','V');


% specify the relative position towards the grid
set(NL.nodes(1),'position',[0.3 0 0.3 0]);
set(NL.nodes(2),'position',[0.4 0.3 0.4 0.3]);
set(NL.nodes(3),'position',[0.7 1 0.7 1]);
set(NL.nodes(4),'position',[1 1.25 1 1.25]);

% specify the orientation
set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','left');
set(NL.nodes(3).block,'orientation','left');
set(NL.nodes(4).block,'orientation','down');

% set up the parameter
pgain = {'0'}; qgain = {'0'}; ladgain = {'0'};
pgain = NL.coeff2str(num,info.nstages);
qgain = NL.coeff2str(conj(num),info.nstages);
ladgain = NL.coeff2str(den,info.nstages);

% Specify coefficient names
plabel = {}; ladlabel = {};
if info.doMapCoeffsToPorts
    plabel{1} = sprintf('%s%d',info.coeffnames{1},info.nstages);
    ladlabel{1} = sprintf('%s%d',info.coeffnames{end},info.nstages);
end

% get delay parameters
if isempty(info.states)
    delay_str = '1,0';  % No state information if empty
else
    delay_str = ['1,' mat2str(info.states(info.nstages,:))];
end

mainparams(1)=filtgraph.indexparam(1,'|+-');
mainparams(2)=filtgraph.indexparam(2,pgain,plabel);
mainparams(3)=filtgraph.indexparam(3,delay_str);
mainparams(4)=filtgraph.indexparam(4,ladgain,ladlabel);

% add input and output
NL.setnode(filtgraph.node('input'),5);
set(NL.nodes(5).block,'label','Input');
set(NL.nodes(5),'position',[-0.5 0 -0.5 0]);
set(NL.nodes(5).block,'orientation','right');
mainparams(5)=filtgraph.indexparam(5,{});

NL.setnode(filtgraph.node('output'),6);
set(NL.nodes(6).block,'label','Output');
set(NL.nodes(6),'position',[2 1.5 2 1.5]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

%add quantization blocks
NL.setnode(filtgraph.node('convertio'),7);
set(NL.nodes(7).block,'label','ConvertIn');
set(NL.nodes(7),'position',[-0.25 0 -0.25 0]);
set(NL.nodes(7).block,'orientation','right');
mainparams(7)=filtgraph.indexparam(7,{});

NL.setnode(filtgraph.node('convertio'),8);
set(NL.nodes(8).block,'label','ConvertOut');
set(NL.nodes(8),'position',[1.7 1.5 1.7 1.5]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});

NL.setnode(filtgraph.node('cast'),9);
set(NL.nodes(9).block,'label','CastState');
set(NL.nodes(9),'position',[0.9 1 0.9 1]);
set(NL.nodes(9).block,'orientation','left');
mainparams(9)=filtgraph.indexparam(9,{});

% specify the qparam
%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.LatticeProdFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);

%Ladder Gain
laddergainqparam.qcoeff=[H.CoeffWordLength H.LadderFracLength];
laddergainqparam.qproduct=[H.ProductWordLength H.LadderProdFracLength];
laddergainqparam.Signed=H.Signed;
laddergainqparam.RoundMode=H.RoundMode;
laddergainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam', laddergainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.LatticeAccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.LatticeAccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
end

%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(5),'qparam',inputqparam);
end

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(7),'qparam',convertinqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(8),'qparam',convertoutqparam);

%connection
NL.connect(1,1,9,1);
NL.connect(9,1,3,1);
NL.connect(9,1,4,1);
NL.connect(2,1,1,2);
NL.connect(3,1,2,1);
NL.connect(5,1,7,1);
NL.connect(7,1,1,1);
NL.connect(4,1,8,1);
NL.connect(8,1,6,1);

Head = filtgraph.stage(NL,[],[],[],[],mainparams);

