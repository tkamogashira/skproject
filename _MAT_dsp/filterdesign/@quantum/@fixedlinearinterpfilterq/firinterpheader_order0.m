function Head = firinterpheader_order0(q,num,interp_order,H,info)

% Copyright 2005 The MathWorks, Inc.

% Construct the first layer, structure specific
NL=filtgraph.nodelist(interp_order+1);

hlocfactor = 1/(interp_order+1);
vlocfactor = 1/(2*interp_order+1);

% Specify coefficient names
nglbl = cell(1,interp_order);
if info.doMapCoeffsToPorts
    for m=1:interp_order
        nglbl{m} = sprintf('%s%d',info.coeffnames{1},m);
    end
end

% connectors & gains
for m=1:interp_order
    %gain
    gainidx = m;   %calculate the node index in the node list
    NL.setnode(filtgraph.node('gain'),gainidx);
    set(NL.nodes(gainidx).block,'label',['headgain' num2str(m)]);
    set(NL.nodes(gainidx),'position',[1-hlocfactor*m vlocfactor*m 1-hlocfactor*m vlocfactor*m]);  %gain aligned backwards
    set(NL.nodes(gainidx).block,'orientation','down');
    ng = {'0'}; 
    ng = NL.coeff2str(num,m);
    mainparams(gainidx)=filtgraph.indexparam(gainidx,ng,nglbl{m});
end

% input
inputidx=interp_order+1;
NL.setnode(filtgraph.node('input'),inputidx);
set(NL.nodes(inputidx).block,'label','Input');
set(NL.nodes(inputidx),'position',[0 0 0 0]);
set(NL.nodes(inputidx).block,'orientation','right');
set(NL.nodes(inputidx).block,'orientation','right');
mainparams(inputidx)=filtgraph.indexparam(inputidx,{});

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
convertinidx = interp_order+2;

NL.connect(inputidx,1,convertinidx,1);
for m=1:interp_order
    gainidx = m;
    NL.connect(convertinidx,1,gainidx,1);
end

% the port to previous and next stage
NextIPorts=[];
NextOPorts=[];
for m=1:interp_order
    NextOPorts = [NextOPorts, filtgraph.nodeport(m,1)];
end

Head = filtgraph.stage(NL,[],[],NextIPorts,NextOPorts,mainparams);
