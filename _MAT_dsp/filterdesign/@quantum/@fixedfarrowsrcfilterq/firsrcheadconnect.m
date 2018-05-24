function [NL, NextIPorts, NextOPorts, mainparams] = firsrcheadconnect(q,NL,H,mainparams,interp_order,flag)
%FIRSRCHEDCONNECT 


%   Copyright 2007 The MathWorks, Inc.

%gain
gainqparam.qcoeff=[H.CoeffWordLength H.CoeffFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;
for m=1:interp_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
end

% add a convertin block
convertinidx = interp_order+3;
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
NL.setnode(filtgraph.node('convertio'),convertinidx);
set(NL.nodes(convertinidx).block,'label','ConvertIn');
set(NL.nodes(convertinidx),'position',[0.2 0 0.2 0]);
set(NL.nodes(convertinidx).block,'orientation','right');
mainparams(convertinidx) = filtgraph.indexparam(convertinidx,{});
set(NL.nodes(convertinidx),'qparam',convertinqparam);

inputidx = interp_order+2;
zohidx = interp_order+1;

% connect input to convert block
NL.connect(inputidx,1,convertinidx,1);

% connect convert block to zoh
NL.connect(convertinidx,1,zohidx,1);

% connect zoh to gains
for m=1:interp_order
    gainidx = m;
    NL.connect(zohidx,1,gainidx,1);
end

NextIPorts=[];

if flag == 1
    NextOPorts= filtgraph.nodeport(convertinidx,1);
else
    NextOPorts = [];    
end

for m=1:interp_order
    NextOPorts = [NextOPorts, filtgraph.nodeport(m,1)];
end

% [EOF]
