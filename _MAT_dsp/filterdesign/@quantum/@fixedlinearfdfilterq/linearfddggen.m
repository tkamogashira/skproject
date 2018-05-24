function DGDF = linearfddggen(this,Hd,states)
%LINEARFDDGGEN   Directed Graph generator for FARROW.LINEARFD

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

% Node List
NL = filtgraph.nodelist(10);
NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('convertio'),2);
NL.setnode(filtgraph.node('input'),3);
NL.setnode(filtgraph.node('convertio'),4);
NL.setnode(filtgraph.node('delay'),5);
NL.setnode(filtgraph.node('sum'),6);
NL.setnode(filtgraph.node('mult'),7);
NL.setnode(filtgraph.node('sum'),8);
NL.setnode(filtgraph.node('convert'),9);
NL.setnode(filtgraph.node('output'),10);

% Labels
set(NL.nodes(1).block,'label','Input');
set(NL.nodes(2).block,'label','ConvertIn');
set(NL.nodes(3).block,'label','FracDelay');
set(NL.nodes(4).block,'label','ConvertFD');
set(NL.nodes(5).block,'label','UnitDelay');
set(NL.nodes(6).block,'label','Sum1');
set(NL.nodes(7).block,'label','Mult');
set(NL.nodes(8).block,'label','Sum2');
set(NL.nodes(9).block,'label','ConvertOut');
set(NL.nodes(10).block,'label','Output');

% Orientation
set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');
set(NL.nodes(3).block,'orientation','right');
set(NL.nodes(4).block,'orientation','right');
set(NL.nodes(5).block,'orientation','down');
set(NL.nodes(6).block,'orientation','right');
set(NL.nodes(7).block,'orientation','right');
set(NL.nodes(8).block,'orientation','right');
set(NL.nodes(9).block,'orientation','right');
set(NL.nodes(10).block,'orientation','right');

% Positions
offset = [-.6 -.8 -.6 -.8];
set(NL.nodes(1),'position',[0 0 0 0] + offset);  
set(NL.nodes(2),'position',[0.25 0 0.25 0] + offset);  
set(NL.nodes(3),'position',[0 .51 0 .51] + offset);  
set(NL.nodes(4),'position',[0.25 .51 0.25 .51] + offset);  
set(NL.nodes(5),'position',[.5 0.125 .5 0.125] + offset);  
set(NL.nodes(6),'position',[1 0.25 1 0.25] + offset);  
set(NL.nodes(7),'position',[1.5 .5 1.5 .5] + offset);  
set(NL.nodes(8),'position',[2 .5 2 .5] + offset);  
set(NL.nodes(9),'position',[2.25 .5 2.25 .5] + offset);  
set(NL.nodes(10),'position',[2.5 .5 2.5 .5] + offset);  

% QParam
convertinqparam.outQ=[this.InputWordLength this.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(2),'qparam',convertinqparam);

convertfdqparam.outQ=[this.FDWordLength this.FDFracLength];
convertfdqparam.Signed=false; 
convertfdqparam.RoundMode='nearest'; 
convertfdqparam.OverflowMode='saturate'; 
set(NL.nodes(4),'qparam',convertfdqparam);

tapsumqparam.sumQ = [this.TapSumWordLength this.TapSumFracLength];
tapsumqparam.RoundMode=this.RoundMode; 
tapsumqparam.OverflowMode=this.OverflowMode; 
set(NL.nodes(6),'qparam',tapsumqparam);

prodqparam.qproduct = [this.ProductWordLength this.ProductFracLength];
prodqparam.RoundMode=this.RoundMode; 
prodqparam.OverflowMode=this.OverflowMode; 
set(NL.nodes(7),'qparam',prodqparam);

accqparam.sumQ = [this.AccumWordLength this.AccumFracLength];
accqparam.RoundMode=this.RoundMode; 
accqparam.OverflowMode=this.OverflowMode; 
set(NL.nodes(8),'qparam',accqparam);

convertoutparam.outQ=[this.OutputWordLength this.OutputFracLength];
convertoutparam.RoundMode=this.RoundMode; 
convertoutparam.OverflowMode=this.OverflowMode; 
set(NL.nodes(9),'qparam',convertoutparam);

% Connections
% NL.connect(source node, source port, dest node, dest port)
NL.connect(1,1,2,1);
NL.connect(2,1,5,1);
NL.connect(2,1,6,1);
NL.connect(2,1,8,1);
NL.connect(5,1,6,2);
NL.connect(6,1,7,1);
NL.connect(3,1,4,1);
NL.connect(4,1,7,2);
NL.connect(7,1,8,2);
NL.connect(8,1,9,1);
NL.connect(9,1,10,1);

% Parameterization
mainparams(1) = filtgraph.indexparam(1,{});
mainparams(2) = filtgraph.indexparam(2,{});
mainparams(3) = filtgraph.indexparam(3,{});
mainparams(4) = filtgraph.indexparam(4,{});
mainparams(5) = filtgraph.indexparam(5,['1,' mat2str(states)]);
mainparams(6) = filtgraph.indexparam(6,'-+|');
mainparams(7) = filtgraph.indexparam(7,'2');
mainparams(8) = filtgraph.indexparam(8,'++|');
mainparams(9) = filtgraph.indexparam(9,{});
mainparams(10) = filtgraph.indexparam(10,{});

Head = filtgraph.stage(NL,[],[],[],[],mainparams);

DGDF = filtgraph.dg_dfilt(Head,'linearfd');





% [EOF]
