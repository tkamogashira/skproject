function Head = df2header_order0(q,num,den,H,info)
%DF2HEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st-order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL = filtgraph.nodelist(3+3);  %a(1)=1 always true in fixed point

NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('output'),3);
NL.setnode(filtgraph.node('convertio'),4);
NL.setnode(filtgraph.node('cast'),5);
NL.setnode(filtgraph.node('convertio'),6);

set(NL.nodes(1).block,'label','Input');
set(NL.nodes(2).block,'label','b');
set(NL.nodes(3).block,'label','Output');
set(NL.nodes(4).block,'label','ConvertIn');
set(NL.nodes(5).block,'label','CastStates');
set(NL.nodes(6).block,'label','ConvertOut');

set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');
set(NL.nodes(3).block,'orientation','right');
set(NL.nodes(4).block,'orientation','right');
set(NL.nodes(5).block,'orientation','right');
set(NL.nodes(6).block,'orientation','right');

set(NL.nodes(1),'position',[0 0 0 0]);  %offset of the grid
set(NL.nodes(2),'position',[2 0 2 0]);  %offset of the grid
set(NL.nodes(3),'position',[3 0 3 0]);  %offset of the grid
set(NL.nodes(4),'position',[0.3 0 0.3 0]);
set(NL.nodes(5),'position',[0.6 0 0.6 0]);
set(NL.nodes(6),'position',[2.5 0 2.5 0]);

% new in fixed point case, need to specify the quantum parameters.
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
end
set(NL.nodes(1),'qparam',inputqparam);

%ConvertIn
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(4),'qparam',convertinqparam);

%RHG
rgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
rgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
rgainqparam.Signed=H.Signed;
rgainqparam.RoundMode=H.RoundMode;
rgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam',rgainqparam);

%CastStates
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',castqparam);

%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',convertoutqparam);

NL.connect(1,1,4,1);
NL.connect(4,1,5,1);
NL.connect(5,1,2,1);
NL.connect(2,1,6,1);
NL.connect(6,1,3,1);

ng = NL.coeff2str(num(1),1);
dg = num2str(1/den(1),'%22.18g');

% add coefficient names for labeling from and goto ports when
% mapcoeffstoports is on.
nlabel = {}; dlabel = {};
if info.doMapCoeffsToPorts
    nlabel{1} = sprintf('%s%d',info.coeffnames{1},1);
    dlabel{1} = sprintf('%s%d',info.coeffnames{2},1);
end

mainparams(2) = filtgraph.indexparam(2,ng,nlabel);
mainparams(1) = filtgraph.indexparam(1,{});
mainparams(3) = filtgraph.indexparam(3,{});
mainparams(4) = filtgraph.indexparam(4,{});
mainparams(5) = filtgraph.indexparam(5,{});
mainparams(6) = filtgraph.indexparam(6,dg,dlabel);


Head = filtgraph.stage(NL,[],[],[],[],mainparams);

