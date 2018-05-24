function Head = dffirheader_order0(q,num,H,info)
%DFFIRHEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL = filtgraph.nodelist(3);

NL.setnode(filtgraph.node('input'),1);
NL.setnode(filtgraph.node('gain'),2);
NL.setnode(filtgraph.node('output'),3);

set(NL.nodes(1).block,'label','Input');
set(NL.nodes(2).block,'label','b');
set(NL.nodes(3).block,'label','Output');

set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');
set(NL.nodes(3).block,'orientation','right');

set(NL.nodes(1),'position',[0 0 0 0]);  %offset of the grid
set(NL.nodes(2),'position',[1 0 1 0]);  %offset of the grid
set(NL.nodes(3),'position',[2 0 2 0]);  %offset of the grid

NL.setnode(filtgraph.node('convertio'),4);
set(NL.nodes(4).block,'label','ConvertIn');
set(NL.nodes(4),'position',[0.5 0 0.5 0]);
set(NL.nodes(4).block,'orientation','right');


NL.setnode(filtgraph.node('convertio'),5);
set(NL.nodes(5).block,'label','ConvertOut');
set(NL.nodes(5),'position',[1.7 0 1.7 0]);
set(NL.nodes(5).block,'orientation','right');

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

%gain
%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
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

% add coefficient names for labeling from and goto ports when
% mapcoeffstoports is on.
nlbl = {};
if info.doMapCoeffsToPorts
    nlbl{1} = sprintf('%s%d',info.coeffnames{1},1);
end

mainparams(2) = filtgraph.indexparam(2,ng,nlbl);
mainparams(1) = filtgraph.indexparam(1,{});
mainparams(3) = filtgraph.indexparam(3,{});
mainparams(4)=filtgraph.indexparam(4,{});
mainparams(5)=filtgraph.indexparam(5,{});

Head = filtgraph.stage(NL,[],[],[],[],mainparams);

