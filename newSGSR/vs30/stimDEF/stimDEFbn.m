function SD = stimDEFbn(SMS);

% stimDEFbn(SMS) - analyze multiplicities of SMSbn params
% and distribute action for generating different waveforms.
STIMCAT = 'bn';

Nsubseq = SMS.Nsubseq;

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
BufVar = prepareBNstim(SMS.StimParam);
BNparam = SMS.StimParam;
SPLvaried = (SMS.StimParam.BNversion>8);
MidFreqvaried = (SMS.StimParam.BNversion<9);

for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   Pres = nthElement(SMS.PRES, isubs);
   % inactive channels needn't be generated
   LeftDead = isequal(Pres.chan,'R');
   RightDead = isequal(Pres.chan,'L');
   makeLeft = ~LeftDead  & (MidFreqvaried | (isubs==1));
   makeRight = ~RightDead & (MidFreqvaried | (isubs==1));
   ipool = [0 0]; % default: no waveform
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = CollectInstruct(isubs, BNparam, Pres);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = CollectInstruct(isubs, BNparam, Pres);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   if isubs>1, % steal wavefrom from previous subseq if needed
      if ~ipool(1), ipool(1) = SD.subseq{isubs-1}.ipool(1); end;
      if ~ipool(2), ipool(2) = SD.subseq{isubs-1}.ipool(2); end;
   end
   % store ipool in subseq 
   SD.subseq{isubs}.ipool = ipool;
   % store # heading/trailing zero samples
   SD.subseq{isubs}.Nhead = [0 0];
   SD.subseq{isubs}.Ntrail = [0 0];
   SD.subseq{isubs}.SPL = Pres.SPL;
   SD.subseq{isubs}.NREP = Pres.Nrep;
   SD.subseq{isubs}.DAmode = Pres.chan;
end; % for isubs





