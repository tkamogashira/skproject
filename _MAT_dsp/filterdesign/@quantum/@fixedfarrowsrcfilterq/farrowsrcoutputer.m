function Outp = farrowsrcoutputer(q,nphases,H,interp_order,decim_order,info)
%FARROWSRCOUTPUTER 

%   Copyright 2007 The MathWorks, Inc.
 
NL=filtgraph.nodelist(3*nphases);
% Nodelist
NL.setnode(filtgraph.node('fixptfracdelay'),1);
for ii=2:3:3*nphases-2,
    NL.setnode(filtgraph.node('convert'),ii);
    NL.setnode(filtgraph.node('mult'),ii+1);
    NL.setnode(filtgraph.node('sum'),ii+2);
end
NL.setnode(filtgraph.node('convert'),3*nphases-1);
NL.setnode(filtgraph.node('output'),3*nphases);

% Labels
set(NL.nodes(1).block,'label','FracDelay');
for ii=2:3:3*nphases-2,
    set(NL.nodes(ii).block,'label',['Convert' num2str(ii/3)]);
    set(NL.nodes(ii+1).block,'label',['Mult' num2str(ii/3)]);
    set(NL.nodes(ii+2).block,'label',['FinalAcc' num2str(ii/3)]);
end
set(NL.nodes(3*nphases-1).block,'label','ConvertOut');
set(NL.nodes(3*nphases).block,'label','Output');

% Orientation 
set(NL.nodes(1).block,'orientation','left');
for ii=2:3:3*nphases-2,
    set(NL.nodes(ii).block,'orientation','right');
    set(NL.nodes(ii+1).block,'orientation','down');
    set(NL.nodes(ii+2).block,'orientation','right');
end
set(NL.nodes(3*nphases-1).block,'orientation','right');
set(NL.nodes(3*nphases).block,'orientation','right');

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

FDComputeFDQ = getfdcomputefxpt(q,interp_order,decim_order);
set(NL.nodes(1),'position',[1.25 0 1.25 0],'qparam',FDComputeFDQ);
k = 1;
set(NL.nodes(2),'position',convertpos(k,nphases),'qparam',MultQ);
set(NL.nodes(3),'position',multpos(k,nphases),'qparam',FDProdQ);
for ii=4:3:3*nphases-1,
    k = k+1;
    set(NL.nodes(ii),'position',sumpos(k,nphases),'qparam',AccQ);
    set(NL.nodes(ii+1),'position',convertpos(k,nphases),'qparam',MultQ);
    set(NL.nodes(ii+2),'position',multpos(k,nphases),'qparam',FDProdQ);    
end
k = k+1;
set(NL.nodes(3*nphases-2),'position',sumpos(k,nphases),'qparam',AccQ);
set(NL.nodes(3*nphases-1),'position',convertpos(k,nphases),'qparam', CoutQ);
set(NL.nodes(3*nphases),'position',convertpos(k,nphases)+[0.5 0 0.5 0]);

% Connections
PrevIPorts=filtgraph.nodeport(2,1);
for ii=2:3:3*(nphases-1)+1,
    NL.connect(1,1,ii+1,2);                 % Input to Mult
    NL.connect(ii,1,ii+1,1);                % Convert to Mult
    NL.connect(ii+1,1,ii+2,1);              % Mult to Sum
    NL.connect(ii+2,1,ii+3,1);              % Sum to Mult (or ConvertOut)
    PrevIPorts = [PrevIPorts filtgraph.nodeport(ii+2,2)];                             %#ok<AGROW>
end
NL.connect(3*nphases-1,1,3*nphases,1);      % ConvertOut to Output

% Parameterization
mainparams(1) = filtgraph.indexparam(1,{});
for ii=2:3:3*nphases-2,
    mainparams(ii) = filtgraph.indexparam(ii,{});
    mainparams(ii+1) = filtgraph.indexparam(ii+1,'2');
    mainparams(ii+2) = filtgraph.indexparam(ii+2,'++|');
end
mainparams(3*nphases-1) = filtgraph.indexparam(3*nphases-1,{});
mainparams(3*nphases) = filtgraph.indexparam(3*nphases,{});

Outp = filtgraph.stage(NL,PrevIPorts,[],[],[],mainparams);

%--------------------------------------------------------------------------
% Utility Functions

function pos = sumpos(stage,nphases)
vlocfactor = 1/(2*nphases+1);
pos = [0.5 vlocfactor*(stage+1)+0.65 0.5 vlocfactor*(stage+1)+0.65];

function pos =convertpos(stage,nphases)
pos = sumpos(stage,nphases)+[0.2 0.0 0.2 0.0];

function pos = multpos(stage,nphases)
pos = sumpos(stage,nphases)+[0.4 0.025 0.4 0.025];


% [EOF]
