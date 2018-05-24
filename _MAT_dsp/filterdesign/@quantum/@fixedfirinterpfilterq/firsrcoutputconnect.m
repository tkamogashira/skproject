function [NL, PrevIPorts, PrevOPorts, mainparams]= firsrcoutputconnect(q,NL,H,mainparams,interp_order)
%FIRSRCOUTPUTCONNECT 

%   Copyright 2007 The MathWorks, Inc.


% add convert out block
NL.setnode(filtgraph.node('convertio'),3);
set(NL.nodes(3).block,'label','ConvertOut');
set(NL.nodes(3),'position',[0.8 1 0.8 1]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3)=filtgraph.indexparam(3,{});

convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(3),'qparam',convertoutqparam);

NL.connect(2,1,3,1);
NL.connect(3,1,1,1);

PrevIPorts=[];
for m=1:interp_order    
    PrevIPorts = [PrevIPorts filtgraph.nodeport(2,m)];      
end
PrevOPorts=[];



% [EOF]
