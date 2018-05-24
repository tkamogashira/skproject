function DGDF = cicdecimdggen(q,Hd,states)
% CICDECIMDGGEN Directed Graph generator for cic decimator filter

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

samplefactor = Hd.DecimationFactor;
diffdelay = Hd.DifferentialDelay;
sectnum = Hd.NumberOfSections;

% Represent the filter in terms of DG_Dfilt
DGDF = gen_DG_cicdecim_stages(q,samplefactor,diffdelay,sectnum,Hd,states);

% -------------------------------------------------------------------------
%
% gen_DG_cicdecim_stages: Generates the DG_DFILT representation
%   by constructing each "Stage" of the filter.
%
% -------------------------------------------------------------------------
function DGDF = gen_DG_cicdecim_stages(q,samplefactor,diffdelay,sectnum,H,states)

info.states = states;
info.nstages = 2*sectnum+3; 

% Create the header, body and the footer.
Stg(1) = inputstage(H,info);
Stg(2) = integstage(sectnum,H,info);
Stg(3) = sampstage(samplefactor,H,info);
Stg(4) = combstage(sectnum,diffdelay,H,info);
Stg(5) = outputstage(H,info);


% make a DG_DFILT out of it.
% dg_dfilt is the bridge between the dfilt representation
% and directed graph representation

DGDF = filtgraph.dg_dfilt(Stg,'cicdecim');
DGDF.expandOrientation='lr';
DGDF.gridGrowingFactor=[0.7 1];

% --------------------------------------------------------------
%
% inputstage: Generate the conceptual input stage for cicdecim architecture
%
%   Returns a filtgraph.stage,
% --------------------------------------------------------------
function Head = inputstage(H,info)

% Construct the first layer, structure specific
NL=filtgraph.nodelist(1);

NL.setnode(filtgraph.node('input'),1);

% specify the block label

set(NL.nodes(1).block,'label','Input');

% specify the relative position towards the grid
set(NL.nodes(1),'position',[0 0 0 0]);

% specify the orientation
set(NL.nodes(1).block,'orientation','right');

% store the useful information into blocks
mainparams(1) = filtgraph.indexparam(1,{});

% Add quantizatio block
NL.setnode(filtgraph.node('convertio'),2);
set(NL.nodes(2).block,'label','ConvertIn');
set(NL.nodes(2),'position',[0.5 0 0.5 0]);
set(NL.nodes(2).block,'orientation','right');
mainparams(2) = filtgraph.indexparam(2,{});

% specify the quantizatio parameters
% input
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
set(NL.nodes(2),'qparam',convertinqparam);


NL.connect(1,1,2,1);

NextIPorts = [];
NextOPorts = [filtgraph.nodeport(2,1)];

% Generate the stage.
Head = filtgraph.stage(NL,[],[],NextIPorts,NextOPorts,mainparams);


% --------------------------------------------------------------
%
% integstage: Generate the conceptual repeating integrator stage for the
% cicdecim architecture
%   Returns a filtgraph.stage,
% --------------------------------------------------------------
function Integ = integstage(sectnum,H,info)

% Generating the repeating middle layers

NL = filtgraph.nodelist(2);

NL.setnode(filtgraph.node('sum'),1);
NL.setnode(filtgraph.node('delay'),2);

set(NL.nodes(1).block,'label','IntSum');
set(NL.nodes(2).block,'label','IntDelay');


set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');

% position defined as (x1,y1,x2,y2) with respect to NW and SW corner of the
% block.  Here we only define the center of the block.  Therefore here
% x1=x2 and y1=y2.  The real position is calculated when the simulink model
% is rendered.  The corresponding block size will be added to the center
% point. x is positive towards right and y is positive towards bottom
set(NL.nodes(1),'position',[0 0 0 0]);
set(NL.nodes(2),'position',[0.5 0 0.5 0]);  

% Get state information for integrator
IC = info.states.Integrator;

% Main parameters of the blocks
sum_str = {}; delay_str={};
for stage = 1:sectnum
    sum_str{stage}='|++';  
    delay_str{stage}=['1,' mat2str(IC(stage,:))];
end
mainparams(1) = filtgraph.indexparam(1,sum_str);
mainparams(2) = filtgraph.indexparam(2,delay_str);

%Set quantization parameters
% IntSum
WLPS = H.SectionWordLengths;
FLPS = H.SectionFracLengths;
for stage = 1:sectnum
    intsumqparam(stage).sumQ = [WLPS(stage) FLPS(stage)];
    intsumqparam(stage).RoundMode = H.RoundMode;
    intsumqparam(stage).OverflowMode = H.OverflowMode;
end
qparams(1) = filtgraph.qindexparam(1,intsumqparam);
qparams(2) = filtgraph.qindexparam(2,[]);

NL.connect(1,1,2,1);
NL.connect(2,1,1,2);
PrevIPorts=[filtgraph.nodeport(1,1)];
PrevOPorts=[];
NextIPorts=[];
NextOPorts=[filtgraph.nodeport(2,1)];

% The number of repetitions
bstages = sectnum;


Integ = filtgraph.stage(NL, PrevIPorts, PrevOPorts,...
    NextIPorts, NextOPorts, mainparams, qparams, bstages);

% --------------------------------------------------------------
%
% sampstage: Generate the conceptual input stage for cicdecim architecture
%
%   Returns a filtgraph.stage,
% --------------------------------------------------------------
function Samp = sampstage(samplefactor,H,info)

% Construct the first layer, structure specific
NL=filtgraph.nodelist(1);

NL.setnode(filtgraph.node('downsample'),1);

% specify the block label

set(NL.nodes(1).block,'label','Down Sample');

% specify the relative position towards the grid
set(NL.nodes(1),'position',[0.5 0 0.5 0]);

% specify the orientation
set(NL.nodes(1).block,'orientation','right');

% store the useful information into blocks
mainparams(1)=filtgraph.indexparam(1,num2str(samplefactor));

PrevIPorts = [filtgraph.nodeport(1,1)];
PrevOPorts = [];
NextIPorts = [];
NextOPorts = [filtgraph.nodeport(1,1)];

% Generate the stage.
Samp = filtgraph.stage(NL,PrevIPorts,PrevOPorts,NextIPorts,NextOPorts,mainparams);

% --------------------------------------------------------------
%
% combstage: Generate the conceptual repeating comb stage for the
% cicdecim architecture
%   Returns a filtgraph.stage,
% --------------------------------------------------------------
function Comb = combstage(sectnum,diffdelay,H,info)

% Generating the repeating middle layers

NL = filtgraph.nodelist(3);

NL.setnode(filtgraph.node('sum'),1);
NL.setnode(filtgraph.node('delay'),2);

set(NL.nodes(1).block,'label','CombSum');
set(NL.nodes(2).block,'label','CombDelay');


set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','down');

% position defined as (x1,y1,x2,y2) with respect to NW and SW corner of the
% block.  Here we only define the center of the block.  Therefore here
% x1=x2 and y1=y2.  The real position is calculated when the simulink model
% is rendered.  The corresponding block size will be added to the center
% point. x is positive towards right and y is positive towards bottom
set(NL.nodes(1),'position',[0.7 0 0.7 0]);  
set(NL.nodes(2),'position',[0.35 0.2 0.35 0.2]);

% Get state information for integrator
IC = info.states.Comb;

% Main parameters of the blocks
sum_str = {}; delay_str={};
for stage = 1:sectnum
    sum_str{stage}='|+-';  
    
    % delay state index
    % The order of the delay parameter needs to be reversed when the delay
    % parameter is more than a unit delay e.g. Z^-2 etc.
    idx = stage*diffdelay;      
    delayparams = IC(idx:-1:idx-diffdelay+1,:);
    if diffdelay > 1
        % We need to transpose the IC when the number of channels is
        % greater than 1, so that it represents a channel by a row vector
        % [g557750].
        delayparams = delayparams.';
    end
    delay_str{stage}=[num2str(diffdelay) ',' mat2str(delayparams)];
end
mainparams(1) = filtgraph.indexparam(1,sum_str);
mainparams(2) = filtgraph.indexparam(2,delay_str);

% To get the correct states, a convert block is required for each comb
% stage
NL.setnode(filtgraph.node('cast'),3);
set(NL.nodes(3).block,'label','CombCast');
set(NL.nodes(3),'position',[0 0 0 0]);
set(NL.nodes(3).block,'orientation','right');
mainparams(3) = filtgraph.indexparam(3,{});


%Set quantization parameters
% IntSum and CombConvert
WLPS = H.SectionWordLengths;
FLPS = H.SectionFracLengths;
for stage = sectnum+1:2*sectnum
    intsumqparam(stage-sectnum).sumQ = [WLPS(stage) FLPS(stage)];
    intsumqparam(stage-sectnum).RoundMode = H.RoundMode;
    intsumqparam(stage-sectnum).OverflowMode = H.OverflowMode;
    castqparam(stage-sectnum).outQ = [WLPS(stage) FLPS(stage)];
    castqparam(stage-sectnum).RoundMode = H.RoundMode;
    castqparam(stage-sectnum).OverflowMode = H.OverflowMode;
end
qparams(1) = filtgraph.qindexparam(1,intsumqparam);
qparams(2) = filtgraph.qindexparam(2,[]);
qparams(3) = filtgraph.qindexparam(3,castqparam);


NL.connect(3,1,1,1);
NL.connect(3,1,2,1);
NL.connect(2,1,1,2);
PrevIPorts=[filtgraph.nodeport(3,1)];
PrevOPorts=[];
NextIPorts=[];
NextOPorts=[filtgraph.nodeport(1,1)];

% The number of repetitions
bstages = sectnum;

Comb = filtgraph.stage(NL, PrevIPorts, PrevOPorts,...
    NextIPorts, NextOPorts, mainparams, qparams, bstages);

% --------------------------------------------------------------
%
% outputstage: Generate the conceptual output stage for cicdecim
% architecture
%
%   Returns a filtgraph.stage,
% --------------------------------------------------------------
function Foot = outputstage(H,info)

% Generate the last layer of the structure.

NL = filtgraph.nodelist(2);

NL.setnode(filtgraph.node('convertio'),1);
NL.setnode(filtgraph.node('output'),2);

set(NL.nodes(1).block,'label','ConvertOut');
set(NL.nodes(2).block,'label','Output');


set(NL.nodes(1).block,'orientation','right');
set(NL.nodes(2).block,'orientation','right');

% position defined as (x1,y1,x2,y2) with respect to NW and SE corner of the
% block.  Here we only define the center of the block.  Therefore here
% x1=x2 and y1=y2.  The real position is calculated when the simulink model
% is rendered.  The corresponding block size will be added to the center
% point. x is positive towards right and y is positive towards bottom
set(NL.nodes(1),'position',[0 0 0 0]);
set(NL.nodes(2),'position',[0.3 0 0.3 0]);  

%ConvertOut
castqparam.outQ=[H.OutputWordLength H.OutputFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(1),'qparam',castqparam);

mainparams(1) = filtgraph.indexparam(1,{});
mainparams(2) = filtgraph.indexparam(2,{});

NL.connect(1,1,2,1);
PrevIPorts=[filtgraph.nodeport(1,1)];
PrevOPorts=[];

Foot = filtgraph.stage(NL, PrevIPorts, PrevOPorts, [], [], mainparams);
