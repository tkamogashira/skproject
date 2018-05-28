function SD = stimDEFnclicks(SMS);

% stimDEFnclicks(SMS) - analyze multiplicities of SMSclick params
% and distribute action for generating different waveforms.
STIMCAT = 'nclicks';

Nsubseq = SMS.Nsubseq;
Fsam = SMS.FREQ.samFreq; % sample freq in Hz
samP = 1e6/Fsam; % sample period in us

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   FREQ = nthElement(SMS.FREQ, isubs);
   PRES = nthElement(SMS.PRES, isubs);
   Nrep = PRES.Nrep;
   Timing = nthElement(SMS.TIMING, isubs);
   Indiv = nthElement(SMS.INDIV, isubs);
   Tindiv = [Indiv.Tleft' Indiv.Tright'];
   RLindiv = [Indiv.RelLevLeft' Indiv.RelLevRight'];
   % is a new wave form needed? Evaluate per channel
   % inactive channels needn't be generated
   LeftDead = isequal(PRES.chan,'R');
   RightDead = isequal(PRES.chan,'L');
   makeLeft =  ~LeftDead;
   makeRight =  ~RightDead;
   ipool = [0 0]; % default: no waveform
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = CombineStruct(chanOfStruct(FREQ,'L'), ...
         chanOfStruct(Timing,'L'));
      SD.waveform{Nwf}.stimpar.Nrep = Nrep;
      SD.waveform{Nwf}.stimpar.T = Tindiv(:,1);
      SD.waveform{Nwf}.stimpar.RL = RLindiv(:,1);
      SD.waveform{Nwf}.stimpar.maxSPL = PRES.maxSPL(1);
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
      SD.waveform{Nwf}.stimpar.T = Tindiv(:,end);
      SD.waveform{Nwf}.stimpar.RL = RLindiv(:,end);
      SD.waveform{Nwf}.stimpar.maxSPL = PRES.maxSPL(end);
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
   SD.subseq{isubs}.Nhead = [0 0];
   SD.subseq{isubs}.Ntrail = [0 0];
   SD.subseq{isubs}.SPL = PRES.SPL;
   SD.subseq{isubs}.NREP = PRES.Nrep;
   SD.subseq{isubs}.DAmode = PRES.chan;
end; % for isubs





