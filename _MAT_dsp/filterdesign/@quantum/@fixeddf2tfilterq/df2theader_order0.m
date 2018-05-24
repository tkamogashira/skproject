function Head = df2theader_order0(q,num,den,H,info)
%DF2THEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL = filtgraph.nodelist(4);

NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('output'),3);
NL.setnode(filtgraph.node('convertio'),4);
NL.setnode(filtgraph.node('convertio'),5);

set(NL.nodes(1).block,'label','Input');
set(NL.nodes(2).block,'label','b');
set(NL.nodes(3).block,'label','Output');
set(NL.nodes(4).block,'label','ConvertIn');
set(NL.nodes(5).block,'label','CastCAS');


set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');
set(NL.nodes(3).block,'orientation','right');
set(NL.nodes(4).block,'orientation','right');
set(NL.nodes(5).block,'orientation','right');

set(NL.nodes(1),'position',[0 0 0 0]);  %offset of the grid
set(NL.nodes(2),'position',[1 0 1 0]);  %offset of the grid
set(NL.nodes(3),'position',[3 0 3 0]);  %offset of the grid
set(NL.nodes(4),'position',[0.5 0 0.5 0]);  %offset of the grid
set(NL.nodes(5),'position',[2.5 0 2.5 0]);

% specify the qparam
%input
if strcmpi(H.RoundMode,'Convergent');
    inputqparam.RoundMode='Convergent';
    set(NL.nodes(1),'qparam',inputqparam);
end
%ConvertIn
%In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur"
%on.
convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
convertinqparam.RoundMode='nearest'; 
convertinqparam.OverflowMode='saturate'; 
set(NL.nodes(4),'qparam',convertinqparam);
% gain
%LHG
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.NumProdFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);
%ConvertOut
convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
convertoutqparam.RoundMode=H.RoundMode;
convertoutqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(5),'qparam',convertoutqparam);


NL.connect(1,1,4,1);
NL.connect(4,1,2,1);
NL.connect(2,1,5,1);
NL.connect(5,1,3,1);

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
mainparams(3) = filtgraph.indexparam(3,{});
mainparams(1) = filtgraph.indexparam(1,{});
mainparams(4) = filtgraph.indexparam(4,{});
mainparams(5) = filtgraph.indexparam(5,dg,dlabel);


Head = filtgraph.stage(NL,[],[],[],[],mainparams);

