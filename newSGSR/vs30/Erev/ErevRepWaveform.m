function YY = ErevRepWaveForm(DataFile, iSeq);
% ErevAnalyze - do revcor analysis
if nargin<1, DataFile=''; end;
if nargin<2, iSeq=inf; end;
if nargin<3, iSubseq=1; end;
if nargin<4, binwidth=1; end; % 1-ms bin with
global SMS SD

YY = CollectInStruct(DataFile, iSeq);
if ischar(DataFile),
   spt = [];
   for iii=iSeq,
      Data = getSGSRdata(DataFile,iii);
      if ~isequal(Data.Header.StimName, 'erev'), return; end;
      SMS = Erev2SMS(Data.Header.StimParams,1,1); % 2nd arg: fake cal; 3rd arg: force computation
      % spt = [spt, Data.SpikeTimes.SubSeq{iSubseq}.Rep{1}]; % spike times im ms
   end
   % spt = sort(spt);
   sim = 0;
else,
   SMS = Erev2SMS(DataFile,1);
   sim = (length(iSeq)>1);
   FF = iSeq; % bandpass filter for simulations
end
Nspikes = length(spt)

if nargin<5, BW = SMS.NOISE.BW; end

% plot(spt)
% reconstruct the stimulus, now using fake calibration
clear sms2prp; % force re-computation of stimuli
sms2prp(0,1); % second arg: save to samplelib; not AP2

iwv = max(SD.subseq{iSubseq}.ipool);
wv = SD.waveform{iwv};
[qq YY.Ctone YY.Cnoise YY.DT] = stimgenErev(wv,'nowhere'); % no storage



