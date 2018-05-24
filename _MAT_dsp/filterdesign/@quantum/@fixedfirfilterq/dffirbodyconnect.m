function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=dffirbodyconnect(q,NL,H,mainparams)
%DFFIRBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

% sum
if H.CastBeforeSum
    %LHS numerator sum
    lsumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
    lsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    lsumqparam.RoundMode = H.RoundMode;
    lsumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(3),'qparam',lsumqparam);
else
    s=getbestprecision(H);
    %LHS
    lsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
    lsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    lsumqparam.RoundMode = H.RoundMode;
    lsumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(3),'qparam',lsumqparam);
end

%gain
%LHG numerator gain
lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
lgainqparam.Signed=H.Signed;
lgainqparam.RoundMode=H.RoundMode;
lgainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', lgainqparam);

%make the connection
NL.connect(1,1,2,1);
NL.connect(2,1,3,1);

% setup the interstage connections
% since in the middle, both previous and next input and output needs to be
% specified.  Note that one stage's number of output has to match the
% number of input in adjacent layers.
PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,2)];
PrevOPorts = [];
NextIPorts = [];
NextOPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,1)];

