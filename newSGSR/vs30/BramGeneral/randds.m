function ds = randds(Type, BurstDur, RepDur, IndepVal, NRep, SPL, SR)
%RANDDS generate dataset with random spiketrains
%   ds = RANDDS(Type, BurstDur, RepDur, IndepVal, NRep) generates dataset of type Type with stimulus
%   duration BurstDur in ms, repetition duration RepDur in ms and number of repetitions given by NRep.
%   The specific values of the independent variable should be supplied in the vector IndepVal.
%   
%   ds = RANDDS(Type, BurstDur, RepDur, IndepVal, NRep, SPL, SR) where SPL is sound level in dB and SR is 
%   the spontanious activity of the cell in spikes/sec.

%B. Van de Sande 02-04-2003

if ~any(nargin == [5,6,7]), error('Wrong number of input parameters.'); end
if nargin == 5, SPL = 50; SR = 20; end
if nargin == 6, SR = 20; end

switch upper(Type);
case 'FS';
    NSubSeq = length(IndepVal);
    for SubSeqNr = 1:NSubSeq
        for RepNr = 1:NRep, SptCell{SubSeqNr, RepNr} = rand(1, randpoisson(SR)) * RepDur; end
    end
    
    %Dataset object aanmaken ...
    ds.ID.FileName     = 'RANDOM';
    ds.ID.FileFormat   = 'SGSR';
    ds.ID.FullFileName = 'RANDOM';
    ds.ID.iSeq         = 1;
    ds.ID.StimType     = upper(Type);
    ds.ID.iCell        = 1;
    ds.ID.SeqID        = sprintf('1-1-%s', upper(Type));
    ds.ID.Time         = clock;
    ds.ID.Place        = ['Leuven\' compuname ];
    ds.ID.Experimenter = 'unknown';
    
    ds.Sizes.Nsub         = NSubSeq;
    ds.Sizes.NsubRecorded = NSubSeq;
    ds.Sizes.Nrep         = NRep;
    
    ds.Data.SpikeTimes   = SptCell;
    ds.Data.OtherData    = [];
    
    ds.Stimulus.IndepVar.Name      = 'Carrier frequency';
    ds.Stimulus.IndepVar.ShortName = 'Fcar';
    ds.Stimulus.IndepVar.Values    =  IndepVal';
    ds.Stimulus.IndepVar.Unit      = 'Hz';
    ds.Stimulus.IndepVar.PlotScale = 'linear';
    
    ds.Stimulus.StimParam.RepDur = RepDur;
    ds.Stimulus.StimParam.RepDur = BurstDur;
    ds.Stimulus.StimParam.SPL    = SPL;
    
    ds.Stimulus.Special.RepDur      = RepDur;
    ds.Stimulus.Special.BurstDur    = BurstDur;
    ds.Stimulus.Special.CarFreq     = NaN;
    ds.Stimulus.Special.ModFreq     = NaN;
    ds.Stimulus.Special.BeatFreq    = NaN;
    ds.Stimulus.Special.BeatModFreq = NaN;
    ds.Stimulus.Special.ActiveChan  = 1;
    
    ds.Settings.SessionInfo.startTime       = clock;
    ds.Settings.SessionInfo.dataFile        = 'RANDOM';
    ds.Settings.SessionInfo.SeqRecorded     = [1:ds.Sizes.NsubRecorded];
    ds.Settings.SessionInfo.RecordingSide   = 1;
    ds.Settings.SessionInfo.DAchannel       = 1;
    
    ds = dataset(ds, 'convert');
otherwise, error(sprintf('%s not implemeted yet.', upper(Type))); end