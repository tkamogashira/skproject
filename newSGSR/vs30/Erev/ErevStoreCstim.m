function [StimPar, isErev] = ErevStoreCstim(DataFile, iSeq, StoreDir);
% ErevStoreCstim - store complex erev stimuli to speed up later analysis
if nargin<3, StoreDir = erevCstimDir; end;
global SMS SD

StimPar = [];
storemap = [StoreDir '\' DataFile]
if ~exist(storemap,'dir'), mkdir(StoreDir,DataFile); end

lastCS = NaN;
lastNontrivial = NaN;
if length(iSeq)>1, more off; end
for iseq=iSeq,
   disp(['storing seq # ', num2str(iseq)]);
   Data = getSGSRdata(DataFile,iseq);
   isErev = isequal('erev',Data.Header.StimName);
   if ~isErev, % no error; that would interrupt batch processing
      disp('error: not an EREV sequence');
   else,
      % store current sample rates
      global SGSR
      curSF = SGSR.samFreqs;
      SGSR.samFreqs = Data.Header.RecordParams.samFreqs;
      StimPar = Data.Header.StimParams;
      SMS = Erev2SMS(StimPar,1,1); % 2nd arg: fake cal; 3rd arg: force computation
      Nsub = SMS.Nsubseq;
      clear sms2prp; % force re-computation of stimuli
      sms2prp(0,1); % second arg: save to samplelib; not AP2
      AdaptDur = SMS.BOTH.Adapt;
      CycDur = SMS.NOISE.dur;
      TotDur = SMS.NOISE.Ncyc*CycDur; % excluding offset ramp & adapt time
      NoiseBW = SMS.NOISE.BW; % noise bandwidth in Hz
      ToneFreq = SMS.TONE.freq; % in Hz
      TotDur = SMS.NOISE.Ncyc*CycDur; % excluding offset ramp & adapt time
      clear newCS;
      for isub = 1:Nsub,
         iwv = max(SD.subseq{isub}.ipool);
         wv = SD.waveform{iwv};
         [qq Ctone Cnoise DT] = stimgenErev(wv,'nowhere'); % no storage
         DT = DT*1e-3; % us->ms
         newCS(1,isub) = CollectInstruct(Ctone, Cnoise, DT, AdaptDur, CycDur, TotDur, ToneFreq, NoiseBW);
      end
      if isequal(newCS, lastCS), % do not store samples - just refer to pevious identical one
         newCS = localFN(storemap, lastNontrivial)
      else, % update lastCS & lastNontrivial
         lastCS = newCS;
         lastNontrivial = iseq;
      end
      Cstim = newCS;
      save(localFN(storemap, iseq),'Cstim','-mat');
      % restore sample rates
      SGSR.samFreqs = curSF;
   end
end


%------
function FN = localFN(mp,ii);
FN = [mp '\Seq' num2str(ii) '.cstim'];


