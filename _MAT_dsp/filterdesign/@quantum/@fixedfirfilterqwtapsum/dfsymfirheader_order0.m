function Head = dfsymfirheader_order0(q,num,H,info)
%DFSYMFIRHEADER_ORDER0 specifies the blocks, connection and quantization parameters in the
%conceptual head stage for a 1st order iir filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

if info.even
    NL=filtgraph.nodelist(7);

    NL.setnode(filtgraph.node('input'),1);
    NL.setnode(filtgraph.node('sum'),2);
    NL.setnode(filtgraph.node('gain'),3);
    NL.setnode(filtgraph.node('delay'),4);
    NL.setnode(filtgraph.node('output'),5);
    NL.setnode(filtgraph.node('convertio'),6);
    NL.setnode(filtgraph.node('convertio'),7);

    % specify the block label

    set(NL.nodes(1).block,'label','Input');
    set(NL.nodes(2).block,'label','HeadSumL');
    set(NL.nodes(3).block,'label','h');
    set(NL.nodes(4).block,'label','HeadDelayR');
    set(NL.nodes(5).block,'label','Output');
    set(NL.nodes(6).block,'label','ConvertIn');
    set(NL.nodes(7).block,'label','ConvertOut');

    % specify the relative position towards the grid
    set(NL.nodes(1),'position',[0 0 0 0]);
    set(NL.nodes(2),'position',[2 0 2 0]);
    set(NL.nodes(3),'position',[3 -0.2 3 -0.2]);
    set(NL.nodes(4),'position',[2.5 0.2 2.5 0.2]);
    set(NL.nodes(5),'position',[4 0 4 0]);
    set(NL.nodes(6),'position',[1 0 1 0]);
    set(NL.nodes(7),'position',[3.7 0 3.7 0]);

    % specify the orientation
    set(NL.nodes(1).block,'orientation','right');
    set(NL.nodes(2).block,'orientation','up');
    set(NL.nodes(3).block,'orientation','right');
    set(NL.nodes(4).block,'orientation','up');
    set(NL.nodes(5).block,'orientation','right');
    set(NL.nodes(6).block,'orientation','right');
    set(NL.nodes(7).block,'orientation','right');

    % Obtain the correct value for the gain block
    ng = NL.coeff2str(num(1),1);
    
    % Specify coefficient names
    nglbl = {};
    if info.doMapCoeffsToPorts
        nglbl{1} = sprintf('%s%d',info.coeffnames{1},1);
    end
    
    % store the useful information into blocks
    mainparams(1)=filtgraph.indexparam(1,{});
    mainparams(2)=filtgraph.indexparam(2,'+|-');
    mainparams(3)=filtgraph.indexparam(3,ng,nglbl);
    mainparams(4)=filtgraph.indexparam(4,'1');
    mainparams(5)=filtgraph.indexparam(5,{});
    mainparams(6)=filtgraph.indexparam(6,{});
    mainparams(7)=filtgraph.indexparam(7,{});

    %input
    if strcmpi(H.RoundMode,'Convergent');
        inputqparam.RoundMode='Convergent';
        set(NL.nodes(1),'qparam',inputqparam);
    end

    %ConvertIn
    %In the ConvertIn block, requires the roundmode as "Nearest" and
    %"DoSatur" on.
    convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
    convertinqparam.RoundMode='nearest';
    convertinqparam.OverflowMode='saturate';
    set(NL.nodes(6),'qparam',convertinqparam);

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
        lsumqparam.sumQ = [H.TapSumWordLength H.TapSumFracLength];
        lsumqparam.RoundMode = H.RoundMode;
        lsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(2),'qparam',lsumqparam);
    else
        s=getbestprecision(H);
        %LHS
        lsumqparam.sumQ = [s.TapSumWordLength s.TapSumFracLength];
        lsumqparam.RoundMode = H.RoundMode;
        lsumqparam.OverflowMode = H.OverflowMode;
        set(NL.nodes(2),'qparam',lsumqparam);
    end

    % setup the interstage connections
    if H.CastBeforeSum
        NL.connect(1,1,6,1);
        NL.connect(6,1,2,1);
        NL.connect(6,1,4,1);
        NL.connect(2,1,3,1);
        NL.connect(4,1,2,2);
        NL.connect(3,1,7,1);
        NL.connect(7,1,5,1);
    else
        NL.setnode(filtgraph.node('convert'),8);
        %LHS,Convert type convert
        set(NL.nodes(8).block,'label','Convert');
        set(NL.nodes(8),'position',[2.2 -0.2 2.2 -0.2]);
        set(NL.nodes(8).block,'orientation','right');
        mainparams(8) = filtgraph.indexparam(8,{});
        convertqparam.outQ=[H.TapSumWordLength H.TapSumFracLength];
        convertqparam.RoundMode=H.RoundMode;
        convertqparam.OverflowMode=H.OverflowMode;
        set(NL.nodes(8),'qparam',convertqparam);
        %making connections
        NL.connect(1,1,6,1);
        NL.connect(6,1,2,1);
        NL.connect(6,1,4,1);
        NL.connect(2,1,8,1);
        NL.connect(8,1,3,1);
        NL.connect(4,1,2,2);
        NL.connect(3,1,7,1);
        NL.connect(7,1,5,1);
    end
else
    NL = filtgraph.nodelist(5);

    NL.setnode(filtgraph.node('input'),1);
    NL.setnode(filtgraph.node('gain'),2);
    NL.setnode(filtgraph.node('output'),3);
    NL.setnode(filtgraph.node('convertio'),4);
    NL.setnode(filtgraph.node('convertio'),5);

    set(NL.nodes(1).block,'label','Input');
    set(NL.nodes(2).block,'label','h');
    set(NL.nodes(3).block,'label','Output');
    set(NL.nodes(4).block,'label','ConvertIn');
    set(NL.nodes(5).block,'label','ConvertOut');

    set(NL.nodes(1).block,'orientation','right');
    set(NL.nodes(2).block,'orientation','right');
    set(NL.nodes(3).block,'orientation','right');
    set(NL.nodes(4).block,'orientation','right');
    set(NL.nodes(5).block,'orientation','right');

    set(NL.nodes(1),'position',[0 0 0 0]);  %offset of the grid
    set(NL.nodes(2),'position',[1 0 1 0]);  %offset of the grid
    set(NL.nodes(3),'position',[2 0 2 0]);  %offset of the grid
    set(NL.nodes(4),'position',[0.5 0 0.5 0]);  %offset of the grid
    set(NL.nodes(5),'position',[1.5 0 1.5 0]);  %offset of the grid

    ng = NL.coeff2str(num(1),1);
    
    % Specify coefficient names
    nglbl = {};
    if info.doMapCoeffsToPorts
        nglbl{1} = sprintf('%s%d',info.coeffnames{1},1);
    end

    mainparams(2) = filtgraph.indexparam(2,ng,nglbl);
    mainparams(1) = filtgraph.indexparam(1,{});
    mainparams(3) = filtgraph.indexparam(3,{});
    mainparams(4) = filtgraph.indexparam(4,{});
    mainparams(5) = filtgraph.indexparam(5,{});
    
    %input
    if strcmpi(H.RoundMode,'Convergent');
        inputqparam.RoundMode='Convergent';
        set(NL.nodes(1),'qparam',inputqparam);
    end

    %ConvertIn
    %In the ConvertIn block, requires the roundmode as "Nearest" and "DoSatur" on.
    %Therefore, we use 'round' and 'saturate' to trigger them.
    convertinqparam.outQ=[H.InputWordLength H.InputFracLength];
    convertinqparam.RoundMode='round';
    convertinqparam.OverflowMode='saturate';
    set(NL.nodes(4),'qparam',convertinqparam);

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


    NL.connect(1,1,4,1);
    NL.connect(4,1,2,1);
    NL.connect(2,1,5,1);
    NL.connect(5,1,3,1);


end


Head = filtgraph.stage(NL,[],[],[],[],mainparams);

