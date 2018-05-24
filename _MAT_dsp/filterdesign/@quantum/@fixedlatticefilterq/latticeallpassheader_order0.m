function Head = latticeallpassheader_order0(q,num,H,info)
%LATTICEALLPASSHEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% Generate the last layer of the structure.

NL=filtgraph.nodelist(5);

NL.setnode(filtgraph.node('sum'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('gain'),3);
NL.setnode(filtgraph.node('sum'),4);
NL.setnode(filtgraph.node('delay'),5);


% specify the block label

set(NL.nodes(1).block,'label','BodyQSum');
set(NL.nodes(2).block,'label','K');
set(NL.nodes(3).block,'label','K*');
set(NL.nodes(4).block,'label','BodyPSum');
set(NL.nodes(5).block,'label','BodyDelay');


% specify the relative position towards the grid
set(NL.nodes(1),'position',[0.3 0 0.3 0]);
set(NL.nodes(2),'position',[0.4 0.3 0.4 0.3]);
set(NL.nodes(3),'position',[0.4 0.7 0.4 0.7]);
set(NL.nodes(4),'position',[0.3 1 0.3 1]);
set(NL.nodes(5),'position',[0.7 1 0.7 1]);

% specify the orientation
set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','left');
set(NL.nodes(3).block,'orientation','left');
set(NL.nodes(4).block,'orientation','left');
set(NL.nodes(5).block,'orientation','left');

% set up the parameter
pgain = {'0'}; qgain = {'0'};
pgain = NL.coeff2str(num,info.nstages);
qgain = NL.coeff2str(conj(num),info.nstages);

% Specify coefficient names
plabel = {}; qlabel = {};
if info.doMapCoeffsToPorts
    plabel{1} = sprintf('%s%d',info.coeffnames{1},info.nstages);
    qlabel{1} = sprintf('%s%d',info.coeffnames{2},info.nstages);
end

mainparams(1)=filtgraph.indexparam(1,'|+-');
mainparams(2)=filtgraph.indexparam(2,pgain,plabel);
mainparams(3)=filtgraph.indexparam(3,qgain,qlabel);
mainparams(4)=filtgraph.indexparam(4,'++|');
mainparams(5)=filtgraph.indexparam(5,['1,' mat2str(info.states(info.nstages,:))]);

% add input and output
NL.setnode(filtgraph.node('input'),6);
set(NL.nodes(6).block,'label','Input');
set(NL.nodes(6),'position',[-0.5 0 -0.5 0]);
set(NL.nodes(6).block,'orientation','right');
mainparams(6)=filtgraph.indexparam(6,{});

NL.setnode(filtgraph.node('output'),7);
set(NL.nodes(7).block,'label','Output');
set(NL.nodes(7),'position',[-0.5 1 -0.5 1]);
set(NL.nodes(7).block,'orientation','left');
mainparams(7)=filtgraph.indexparam(7,{});

% add quantization blocks
NL.setnode(filtgraph.node('convertio'),8);
set(NL.nodes(8).block,'label','ConvertIn');
set(NL.nodes(8),'position',[-0.25 0 -0.25 0]);
set(NL.nodes(8).block,'orientation','right');
mainparams(8)=filtgraph.indexparam(8,{});


NL.setnode(filtgraph.node('convertio'),9);
set(NL.nodes(9).block,'label','ConvertOut');
set(NL.nodes(9),'position',[-0.25 1 -0.25 1]);
set(NL.nodes(9).block,'orientation','left');
mainparams(9)=filtgraph.indexparam(9,{});

NL.setnode(filtgraph.node('cast'),10);
set(NL.nodes(10).block,'label','CastInProd');
set(NL.nodes(10),'position',[0.6 0.7 0.6 0.7]);
set(NL.nodes(10).block,'orientation','left');
mainparams(10)=filtgraph.indexparam(10,{});

NL.setnode(filtgraph.node('cast'),11);
set(NL.nodes(11).block,'label','CastState');
set(NL.nodes(11),'position',[0.9 1 0.9 1]);
set(NL.nodes(11).block,'orientation','left');
mainparams(11)=filtgraph.indexparam(11,{});

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(6),'qparam',inputqparam);
end

%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(8),'qparam',convertinqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(9),'qparam',convertoutqparam);

%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(10),'qparam',castqparam);
set(NL.nodes(11),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);
set(NL.nodes(3),'qparam', latticegainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
end

%connection
NL.connect(1,1,10,1);
NL.connect(1,1,11,1);
NL.connect(2,1,1,2);
NL.connect(3,1,4,1);
NL.connect(4,1,9,1);
NL.connect(5,1,2,1);
NL.connect(5,1,4,2);
NL.connect(6,1,8,1);
NL.connect(8,1,1,1);
NL.connect(9,1,7,1);
NL.connect(10,1,3,1);
NL.connect(11,1,5,1);

Head = filtgraph.stage(NL,[],[],[],[],mainparams);

