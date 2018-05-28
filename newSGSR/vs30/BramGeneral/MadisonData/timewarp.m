function ds = TimeWarp(ds)
%TIMEWARP   timewarp Wisconsin-data.
%   ds = TIMEWARP(ds) timewarps the dataset object ds. This is to correct a stimulus artefact that was introduced
%   while recording with oscillating correlation(OSCOR).
%   Attention! This is automatically done when using DAT2DS to load datasets recorded at the University of Wisconsin.
%
%   See also MADDATASET

%B. Van de Sande 8-04-2003

DirInfo = getdirinfo('oscor'); if isempty(DirInfo), error('Couldn''t get directory information'); end

if ~strcmp(ds.FileFormat, 'MADDATA'), error('Dataset doesn''t contain Wisconsin-data'); end
if ~any(strcmpi(ds.StimType, {'NSPL', 'OSCR', 'OSCRCTL', 'OSCRTD'})), error('Unknown stimulustype'); end

DataType  = ds.StimType;
FilterType = ds.StimParam.FilterType;
NSubRec   = ds.nsubrecorded;
NRep      = ds.nrep;
switch DataType
case {'NSPL', 'OSCRTD'}
   ModFreq = repmat(ds.StimParam.ModFreq, 1, NSubRec); 
case 'NITD', return;   
case {'OSCR', 'OSCRCTL'}
   ModFreq = ds.indepval;
end
StimDirName = [DirInfo.MadStimDir  FilterType '\'];

SpikeTimes = cell(0);
for SubSeqNr = 1:NSubRec
    if isnan(ModFreq(SubSeqNr)), SpikeTimes(SubSeqNr, :) = ds.spt(SubSeqNr, :); continue; end
    
    ModSin = GetModWave(StimDirName, 'sin', ModFreq(SubSeqNr));
    ModCos = GetModWave(StimDirName, 'cos', ModFreq(SubSeqNr));
    SpikeTimes(SubSeqNr, :) = SubSeqTWarp(ds.spt(SubSeqNr, :), ModFreq(SubSeqNr), ModSin, ModCos);
    
    %NaN verwijderen uit spiketrain ...
    for RepNr = 1:NRep, SpikeTimes{SubSeqNr, RepNr} = SpikeTimes{SubSeqNr, RepNr}(find(~isnan(SpikeTimes{SubSeqNr, RepNr}))); end
end   

ds = struct(ds);
ds.Data.SpikeTimes = SpikeTimes;
ds = dataset(ds, 'convert');

%Lokale functie ...
function ModWave = GetModWave(StimDirName, WaveType, ModFreq)

if ~any(strcmpi(WaveType, {'sin', 'cos'})), error('Wavetype should be sin or cos'); end

load([StimDirName upper(WaveType) int2str(ModFreq)]); 
ModWave = eval([lower(WaveType) int2str(ModFreq) ';']);
    
function spiketrain = SubSeqTWarp(spiketrain, modfreq, ModSin, ModCos);

phase   = unwrap(atan2(ModSin(:,2), ModCos(:,2)));
ncycles = phase / (2*pi);

for i = 1:size(spiketrain,2)
    spiketrain{i} = interp1(ModSin(:,1),ncycles,spiketrain{i}) * (1000/modfreq);
end
