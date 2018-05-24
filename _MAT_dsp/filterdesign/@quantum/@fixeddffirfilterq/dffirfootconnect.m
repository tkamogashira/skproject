function [NL, PrevIPorts, PrevOPorts, mainparams]=dffirfootconnect(q,NL,H,mainparams);
%DFFIRFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

NL.setnode(filtgraph.node('convertio'),5);
set(NL.nodes(5).block,'label','ConvertOut');
set(NL.nodes(5),'position',[2.7 0 2.7 0]);
set(NL.nodes(5).block,'orientation','right');
mainparams(5)=filtgraph.indexparam(5,{});


s=getbestprecision(H);
%LHS
lsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
lsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
lsumqparam.RoundMode = H.RoundMode;
lsumqparam.OverflowMode = H.OverflowMode;
set(NL.nodes(3),'qparam',lsumqparam);

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


%make the connection
NL.connect(1,1,2,1);
NL.connect(2,1,3,2);
NL.connect(3,1,5,1);
NL.connect(5,1,4,1);

% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1)];
PrevOPorts = [];
