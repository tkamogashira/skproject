function Outp = fdfarrowoutputer(q,nphases,H,info)
%FDFARROWOUTPUTER   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

NL=filtgraph.nodelist(3*nphases+1);

% Nodelist
NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('convertio'),2);
for ii=3:3:3*(nphases-1)+2,
    NL.setnode(filtgraph.node('convert'),ii);
    NL.setnode(filtgraph.node('mult'),ii+1);
    NL.setnode(filtgraph.node('sum'),ii+2);
end
NL.setnode(filtgraph.node('convert'),3*nphases);
NL.setnode(filtgraph.node('output'),3*nphases+1);


% Labels
set(NL.nodes(1).block,'label','FracDelay');
set(NL.nodes(2).block,'label','ConvertFD');
for ii=3:3:3*(nphases-1)+2,
    set(NL.nodes(ii).block,'label',['Convert' num2str(ii/3)]);
    set(NL.nodes(ii+1).block,'label',['Mult' num2str(ii/3)]);
    set(NL.nodes(ii+2).block,'label',['FinalAcc' num2str(ii/3)]);
end
set(NL.nodes(3*nphases).block,'label','ConvertOut');
set(NL.nodes(3*nphases+1).block,'label','Output');

% Orientation 
set(NL.nodes(1).block,'orientation','left');
set(NL.nodes(2).block,'orientation','left');
for ii=3:3:3*(nphases-1)+2,
    set(NL.nodes(ii).block,'orientation','right');
    set(NL.nodes(ii+1).block,'orientation','down');
    set(NL.nodes(ii+2).block,'orientation','right');
end
set(NL.nodes(3*nphases).block,'orientation','right');
set(NL.nodes(3*nphases+1).block,'orientation','right');

% Positions and qparam
CfdQ.outQ=[q.FDWordLength q.FDFracLength];
CfdQ.Signed=false; 
CfdQ.RoundMode='nearest'; 
CfdQ.OverflowMode='saturate'; 

CoutQ.outQ=[q.OutputWordLength q.OutputFracLength];
CoutQ.RoundMode=q.RoundMode; 
CoutQ.OverflowMode=q.OverflowMode; 

MultQ.outQ = [q.MultiplicandWordLength q.MultiplicandFracLength];
MultQ.RoundMode=q.RoundMode; 
MultQ.OverflowMode=q.OverflowMode; 

FDProdQ.qproduct = [q.FDProdWordLength q.FDProdFracLength];
FDProdQ.RoundMode=q.RoundMode; 
FDProdQ.OverflowMode=q.OverflowMode; 

accfl = max(q.FDProdFracLength,q.AccumFracLength);
accwl = accfl + ...
    max(q.FDProdWordLength-q.FDProdFracLength,q.AccumWordLength-q.AccumFracLength) + ...
    1;
AccQ.sumQ = [accwl accfl];
AccQ.RoundMode=q.RoundMode; 
AccQ.OverflowMode=q.OverflowMode; 

vlocfactor = 1/(2*nphases+1);
set(NL.nodes(1),'position',[1 0 1 0]);
set(NL.nodes(2),'position',[.75 0 .75 0],'qparam',CfdQ);
for ii=3:3:3*(nphases-1)+2,
    set(NL.nodes(ii),'position',[0.25 0.5+3*vlocfactor*(ii/3) 0.25 0.5+3*vlocfactor*(ii/3)],'qparam',MultQ);
    set(NL.nodes(ii+1),'position',[0.5 0.37+3*vlocfactor*(ii/3+1) 0.5 0.37+3*vlocfactor*(ii/3+1)],'qparam',FDProdQ);
    set(NL.nodes(ii+2),'position',[0 0.5+3*vlocfactor*(ii/3+1) 0 0.5+3*vlocfactor*(ii/3+1)],'qparam',AccQ);
end
set(NL.nodes(3*nphases),...
    'position', [0.25 .5+3*vlocfactor*nphases 0.25 .5+3*vlocfactor*nphases], ...
    'qparam', CoutQ);
set(NL.nodes(3*nphases+1),'position',[0.5 .5+3*vlocfactor*nphases 0.5 .5+3*vlocfactor*nphases]);

% Connections
PrevIPorts=filtgraph.nodeport(3,1);
NL.connect(1,1,2,1);      % Input to Convert
for ii=3:3:3*(nphases-1)+2,
    NL.connect(2,1,ii+1,2);      % ConvertIn to mult
    NL.connect(ii,1,ii+1,1);     % Convert to mult
    NL.connect(ii+1,1,ii+2,1);   % mult to sum
    NL.connect(ii+2,1,ii+3,1);   % sum to mult (or convertout)
    PrevIPorts = [PrevIPorts filtgraph.nodeport(ii+2,2)];
end
NL.connect(3*nphases,1,3*nphases+1,1);      % ConvertOut to Output


% Parameterization
mainparams(1) = filtgraph.indexparam(1,{});
mainparams(2) = filtgraph.indexparam(2,{});
for ii=3:3:3*(nphases-1)+2,
    mainparams(ii) = filtgraph.indexparam(ii,{});
    mainparams(ii+1) = filtgraph.indexparam(ii+1,'2');
    mainparams(ii+2) = filtgraph.indexparam(ii+2,'++|');
end
mainparams(3*nphases) = filtgraph.indexparam(3*nphases,{});
mainparams(3*nphases+1) = filtgraph.indexparam(3*nphases+1,{});

Outp = filtgraph.stage(NL,PrevIPorts,[],[],[],mainparams);


% [EOF]
