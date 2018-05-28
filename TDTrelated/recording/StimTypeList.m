function StimType=StimTypeList
%StimTypeList  -- Set the list of stimulus types
%Each entry of cell array StimType referres to a type of stimulus,
%which is used as a stimulus-type ID for STIM (global variable that
%specifies stimlus conditions), is the m-function name for generating
%a stimulus, and appeares in the 'Stim Type' popup menu of Experiment
%Manager.
%By SF, 9/28/01

global StimType
StimType=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tone -- Single tone burst
myStimType={'Tone','Freq','SPL','ITD','FixEnvFlag','ILD','[Silence1 ToneDur Silence2 Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% Noise -- Gaussian noise burst
myStimType={'Noise','[PassbandLo PassbandHi]','FiltOrder','SPL','ITD','UncorrelatedFlag','ILD','[Silence1 NoiseDur Silence2 Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% AdaptIPD -- two-tone sequence ('adapter' and 'probe')
myStimType={'AdaptIPD','[AdaptDur, AdaptFreq, AdaptSPL, AdaptITD]','GapDur',...
        '[ProbeDur, ProbeFreq, ProbeSPL, ProbeITD]','FixEnvFlag','[Silence1, Silence2, Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% DynIPD -- Dynamic IPD
myStimType={'DynIPD','Freq','SPL',...
        'CenterIPD','IPDRange','Period','[Silence1, Silence2, Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% Files -- The data in files
myStimType={'Files','PathName','FileName','Silence','SPL'}; 
StimType=AppendCell(StimType,myStimType);

% EchoStim -- Echo
myStimType={'EchoStim','Source','SPL','AmpRatio','Delay','ITD','ILD','[Silence1 NoiseDur Silence2 Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% CombNoise -- comb-filtered noise, mimicing the interference of the direct
% and the reflected sound
myStimType={'CombNoise','[PassbandLo PassbandHi]','FiltOrder','SPL','Delay','ITD','ILD','[Silence1 NoiseDur Silence2 Ramp]'}; 
StimType=AppendCell(StimType,myStimType);

% ILD -- Signels that differ between the ears
myStimType={'ILD','Freq','SPL','ILD','[Silence1 ToneDur]','[TotalDur RampDur]'}; 
StimType=AppendCell(StimType,myStimType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function c12=AppendCell(c1,c2)

if isempty(c1)
    c12=c2;
else
    
    [nrow1,ncol1]=size(c1);
    [nrow2,ncol2]=size(c2);
    
    d=ncol2-ncol1;
    if d>0
        myc=cell(nrow1,d);
        myc(:)=deal({'-'});
        c12=[[c1 myc]; c2];
    else
        myc=cell(nrow2,-d);
        myc(:)=deal({'-'});
        c12=[c1; [c2 myc]];
    end    
end    
