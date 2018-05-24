function [NL, PrevIPorts, PrevOPorts, mainparams]=dfsymfirfootconnect(q,NL,H,mainparams,info);
%DFSYMFIRFOOTCONNECT specifies the connection and quantization parameters in the
%conceptual foot stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

if info.even
    NL.setnode(filtgraph.node('convertio'),7);
    set(NL.nodes(7).block,'label','ConvertOut');
    set(NL.nodes(7).block,'orientation','right');
    set(NL.nodes(7),'position',[4.7 0 4.7 0]);
    mainparams(7)=filtgraph.indexparam(7,{});
    
    %ConvertOut
    convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
    convertoutqparam.RoundMode=H.RoundMode;
    convertoutqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(7),'qparam',convertoutqparam);
    
    %LHG numerator gain
    lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
    lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
    lgainqparam.Signed=H.Signed;
    lgainqparam.RoundMode=H.RoundMode;
    lgainqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(3),'qparam', lgainqparam);
    
    if H.CastBeforeSum
        %LHS numerator sum
        lsumqparam.AccQ = [H.TapSumWordLength H.TapSumFracLength];
        lsumqparam.sumQ = [H.TapSumWordLength H.TapSumFracLength];
        lsumqparam.RoundMode = H.RoundMode;
        lsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(2),'qparam',lsumqparam);
        %RHS numerator sum
        rsumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.RoundMode = H.RoundMode;
        rsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(5),'qparam',rsumqparam);
    else
        s=getbestprecision(H);
        %LHS
        lsumqparam.AccQ = [s.TapSumWordLength s.TapSumFracLength];
        lsumqparam.sumQ = [H.TapSumWordLength H.TapSumFracLength];
        lsumqparam.RoundMode = H.RoundMode;
        lsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(2),'qparam',lsumqparam);
        %RHS
        rsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
        rsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.RoundMode = H.RoundMode;
        rsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(5),'qparam',rsumqparam);
    end
    
    %make the connection
    NL.connect(1,1,2,1);
    NL.connect(1,1,4,1);
    NL.connect(2,1,3,1);
    NL.connect(4,1,2,2);
    NL.connect(3,1,5,1);
    NL.connect(5,1,7,1);
    NL.connect(7,1,6,1);
    PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(5,2)];
    PrevOPorts = [filtgraph.nodeport(4,1)];
    
    
else
    NL.setnode(filtgraph.node('convertio'),5);
    set(NL.nodes(5).block,'label','ConvertOut');
    set(NL.nodes(5).block,'orientation','right');
    set(NL.nodes(5),'position',[4.7 0 4.7 0]);
    mainparams(5)=filtgraph.indexparam(5,{});
    
    %ConvertOut
    convertoutqparam.outQ=[H.OutputWordLength H.OutputFracLength];
    convertoutqparam.RoundMode=H.RoundMode;
    convertoutqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(5),'qparam',convertoutqparam);
    
    %LHG numerator gain
    lgainqparam.qcoeff=[H.CoeffWordLength H.NumFracLength];
    lgainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
    lgainqparam.Signed=H.Signed;
    lgainqparam.RoundMode=H.RoundMode;
    lgainqparam.OverflowMode=H.OverflowMode;
    set(NL.nodes(2),'qparam', lgainqparam);
    
    if H.CastBeforeSum
        %RHS numerator sum
        rsumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.RoundMode = H.RoundMode;
        rsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(3),'qparam',rsumqparam);
    else
        s=getbestprecision(H);
        %RHS
        rsumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
        rsumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
        rsumqparam.RoundMode = H.RoundMode;
        rsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(3),'qparam',rsumqparam);
    end
    
    %make the connection
    NL.connect(1,1,2,1);
    NL.connect(2,1,3,1);
    NL.connect(3,1,5,1);
    NL.connect(5,1,4,1);
    PrevIPorts = [filtgraph.nodeport(1,1) filtgraph.nodeport(3,2)];
    PrevOPorts = [filtgraph.nodeport(1,1)];
    
end
