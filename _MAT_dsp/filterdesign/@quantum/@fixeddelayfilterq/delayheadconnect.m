function [NL, NextIPorts, NextOPorts, mainparams]=delayheadconnect(q,NL,H,mainparams)
%DELAYHEADCONNECT specifies connection and quantization parameters in the
%conceptual head stage

%   Copyright 2009 The MathWorks, Inc.

%Add quantization blocks
NL.setnode(filtgraph.node('convertio'),4);
set(NL.nodes(4).block,'label','ConvertIn');
set(NL.nodes(4),'position',[0.5 0 0.5 0]);
set(NL.nodes(4).block,'orientation','right');
mainparams(4)=filtgraph.indexparam(4,{});


%ConvertIn
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
set(NL.nodes(4),'qparam',convertinqparam);

% specify the connection
NL.connect(1,1,4,1);
NL.connect(4,1,2,1);
NL.connect(2,1,3,1);

% specify interstage connection
NextIPorts=[];
NextOPorts=[];

% [EOF]

