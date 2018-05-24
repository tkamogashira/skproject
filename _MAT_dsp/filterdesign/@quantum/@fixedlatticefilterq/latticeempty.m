function Head = latticeempty(q,num,H,info)
%LATTICEEMPTY specifies a filter with empty lattice.  It passes the input
%through the output unchanged

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.


% --------------------------------------------------------------
%
% head: Generate the conceptual header stage for Discrete FIR architecture
%
%   Returns a filtgraph.stage,
% --------------------------------------------------------------


% Construct the first layer, structure specific
NL=filtgraph.nodelist(4);

NL.setnode(filtgraph.node('input'),1);
set(NL.nodes(1).block,'label','Input');
set(NL.nodes(1),'position',[0 0 0 0]);
set(NL.nodes(1).block,'orientation','right');
mainparams(1)=filtgraph.indexparam(1,{});

%add output
NL.setnode(filtgraph.node('output'),2);
set(NL.nodes(2).block,'label','Output');
set(NL.nodes(2),'position',[1 0 1 0]);
set(NL.nodes(2).block,'orientation','right');
mainparams(2)=filtgraph.indexparam(2,{});

% add quantization blocks
NL.setnode(filtgraph.node('convertio'),3);
set(NL.nodes(3).block,'label','ConvertIn');
set(NL.nodes(3),'position',[0.3 0 0.3 0]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3)=filtgraph.indexparam(3,{});


NL.setnode(filtgraph.node('convertio'),4);
set(NL.nodes(4).block,'label','ConvertOut');
set(NL.nodes(4),'position',[0.7 0 0.7 0]);
set(NL.nodes(4).block,'orientation','right');
mainparams(4)=filtgraph.indexparam(4,{});

% specify the qparam
%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur" on.
%Therefore, we use 'round' and 'saturate' to trigger them.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='round'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(3),'qparam',convertinqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(4),'qparam',convertoutqparam);

% specify the connection
% NL.connect(source node, source port, dest node, dest port)
% note that input and output are numbered separately
NL.connect(1,1,3,1);
NL.connect(3,1,4,1);
NL.connect(4,1,2,1);

% Generate the stage.
Head = filtgraph.stage(NL,[],[],[],[],mainparams);
