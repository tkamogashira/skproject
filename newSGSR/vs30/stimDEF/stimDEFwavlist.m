function SD = stimDEFwavList(SMS);

% stimDEFwavList(SMS) - analyze Wavlist-type SMS params
% and distribute action for generating different waveforms

Nsubseq = length(SMS.PRP.playOrder);

% trailing zero samples to make each playing of waveform last equally long
Nhead = SMS.BIN.Nhead; 
Ntrail = max(max(Nhead)) - Nhead;

SD = []; 
SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
for isubs=1:Nsubseq,
   % avoid slow, recursive, calls to nthelement
   % so split up instead of SMSi = ntheElement(SMS)
   SMSi.BIN = nthElement(SMS.BIN, isubs);
   SMSi.MON = nthElement(SMS.MON, isubs);
   % Diotic = isequal(SMSi.LEFT, SMSi.RIGHT);
   Diotic = 0; % channel-wise calibration spoils equality of waveforms
   % is a new wave form needed? Evaluate per channel
   LeftDead = isequal(SMSi.BIN.chan,'R');
   RightDead = isequal(SMSi.BIN.chan,'L');
   makeLeft = ~LeftDead;
   makeRight = ~RightDead;
   makeRight = makeRight & ~(Diotic & makeLeft);
   ipool = [0 0]; % default: no waveform
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = 'WAVlist';
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = SMSi.MON;
      SD.waveform{Nwf}.stimpar.WAVdataIndex = isubs;
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = 'WAVlist';
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = SMSi.MON;
      SD.waveform{Nwf}.stimpar.WAVdataIndex = isubs;
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   % store ipool in subseq 
   SD.subseq{isubs}.ipool = ipool;
   % store # heading/trailing zero samples
   SD.subseq{isubs}.Nhead = Nhead(isubs,:);
   SD.subseq{isubs}.Ntrail = Ntrail(isubs,:);
   SD.subseq{isubs}.ATTEN = nthElement(SMS.ATTEN, isubs);
   SD.subseq{isubs}.NREP = nthElement(SMS.NREP, isubs);
   % DAmode: L/R/D/B = left/right/diotic/binaural
   DAmode = SMSi.BIN.chan; % here 'B' means Both, which can ..
   % ... either imply binaural ('B') or diotic ('D').
   if isequal(DAmode,'B') & Diotic, DAmode = 'D'; end;
   SD.subseq{isubs}.DAmode = DAmode;
   SD.subseq{isubs}.AnaAtten = nthElement(SMS.ATTEN, isubs);
end; % for isubs

% indicate skipping of LevelChecking function
SD.NoLevelChecking = 1;




