function [NL, NextIPorts, NextOPorts, mainparams]=firinterpheadconnect(q,NL,H,mainparams,interp_order)

% Copyright 2005 The MathWorks, Inc.

% Specify qparams

%gain
gainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
gainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
gainqparam.Signed=H.Signed;
gainqparam.RoundMode=H.RoundMode;
gainqparam.OverflowMode=H.OverflowMode;
for m=1:interp_order
    gainidx = m;
    set(NL.nodes(gainidx),'qparam',gainqparam);
end

% add a convertin block
convertinidx = interp_order+2;
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest';
convertinqparam.OverflowMode='saturate';
NL.setnode(filtgraph.node('convertio'),convertinidx);
set(NL.nodes(convertinidx).block,'label','ConvertIn');
set(NL.nodes(convertinidx),'position',[0.2 0 0.2 0]);
set(NL.nodes(convertinidx).block,'orientation','right');
mainparams(convertinidx) = filtgraph.indexparam(convertinidx,{});
set(NL.nodes(convertinidx),'qparam',convertinqparam);


% connections
% connect connectors to gains
inputidx = interp_order+1;

NL.connect(inputidx,1,convertinidx,1);
for m=1:interp_order
    gainidx = m;
    NL.connect(convertinidx,1,gainidx,1);
end

% the port to previous and next stage
NextIPorts=[];
NextOPorts=[filtgraph.nodeport(convertinidx,1)];
for m=1:interp_order
    NextOPorts = [NextOPorts, filtgraph.nodeport(m,1)];
end
