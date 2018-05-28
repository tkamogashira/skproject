function SD = stimDEFclick(SMS);

% stimDEFclick(SMS) - analyze multiplicities of SMSclick params
% and distribute action for generating different waveforms.
STIMCAT = 'click';

Nsubseq = SMS.Nsubseq;
Fsam = SMS.FREQ.samFreq; % sample freq in Hz
samP = 1e6/Fsam; % sample period in us
ITD = SMS.TIMING.totalITD;

% trailing zero samples to make each playing of waveform last equally long
Nhead = ITD.Nhead;
if size(Nhead,1)==1,
   Nhead = repmat(Nhead,Nsubseq,1);
end
Ntrail = max(max(Nhead)) - Nhead;
% extra time needed for heading/trailing zeros (needed for checking repDur)
ExtraTime = max(max(Nhead))*samP*1e-3; % in ms

% variation of left and right channels individually
LeftConstant = SMS.SD_INSTR.LeftConstant;
RightConstant = SMS.SD_INSTR.RightConstant;

% in which channel is the ITD expressed?
ITDchan = SMS.SD_INSTR.ITDchan;

OneWaveformPair = LeftConstant & RightConstant;

SMS.TIMING.totDur = SMS.TIMING.burstDur;
% increase repDur if totDurs do not fit
repDur = SMS.TIMING.repDur; % might be column vector
repDur = max(repDur, SMS.TIMING.totDur(:,1)+ExtraTime); % left channel
repDur = max(repDur, SMS.TIMING.totDur(:,2)+ExtraTime); % right channel

% retrieve info on click trains that has been evaluated at stimMenu time
global clickData
NCD = length(clickData);

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   clickDataIndex = min(NCD,isubs);
   clickInfo = clickData(clickDataIndex);
   FREQ = nthElement(SMS.FREQ, isubs);
   PRES = nthElement(SMS.PRES, isubs);
   Nrep = PRES.Nrep;
   Timing = nthElement(SMS.TIMING, isubs);
   % is a new wave form needed? Evaluate per channel
   makeLeft = ~LeftConstant | (isubs==1);
   makeRight = ~RightConstant | (isubs==1);
   % inactive channels needn't be generated
   LeftDead = isequal(PRES.chan,'R');
   RightDead = isequal(PRES.chan,'L');
   makeLeft = makeLeft & ~LeftDead;
   makeRight = makeRight & ~RightDead;
   ipool = [0 0]; % default: no waveform
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = CombineStruct(chanOfStruct(FREQ,'L'), ...
         chanOfStruct(Timing,'L'));
      SD.waveform{Nwf}.stimpar.Nrep = Nrep;
      SD.waveform{Nwf}.stimpar.clickDataIndex = clickDataIndex;
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = CombineStruct(chanOfStruct(FREQ,'R'), ...
         chanOfStruct(Timing,'R'));
      SD.waveform{Nwf}.stimpar.Nrep = Nrep;
      SD.waveform{Nwf}.stimpar.clickDataIndex = clickDataIndex;
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   % correct zero pool values for active channels
   if ~LeftDead,
      if isequal(ipool(1),0),
         if LeftConstant, % steal from previous subseq
            ipool(1) = SD.subseq{isubs-1}.ipool(1);
         end
      end
   end
   if ~RightDead,
      if isequal(ipool(2),0),
         if RightConstant, % steal from previous subseq
            ipool(2) = SD.subseq{isubs-1}.ipool(2);
         end
      end
   end
   % store ipool in subseq 
   SD.subseq{isubs}.ipool = ipool;
   % store # heading/trailing zero samples
   SD.subseq{isubs}.Nhead = Nhead(isubs,:);
   SD.subseq{isubs}.Ntrail = Ntrail(isubs,:);
   SD.subseq{isubs}.SPL = PRES.SPL;
   SD.subseq{isubs}.NREP = PRES.Nrep;
   SD.subseq{isubs}.DAmode = PRES.chan;
end; % for isubs





