function SD = stimDEFlinfm(SMS);

% stimDEFlfm(SMS) - analyze multiplicities of SMSlinfm params
% and distribute action for generating different waveforms.
STIMCAT = 'linfm';

Nsubseq = SMS.Nsubseq;

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter

for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   Sweep = nthElement(SMS.SWEEP, isubs);
   Pres = nthElement(SMS.PRES, isubs);
   % inactive channels needn't be generated
   LeftDead = isequal(Pres.chan,'R');
   RightDead = isequal(Pres.chan,'L');
   makeLeft = ~LeftDead;
   makeRight = ~RightDead;
   ipool = [0 0]; % default: no waveform
   noiseIndex = isubs; % used as noise buffer index
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = chanOfStruct(Sweep,'L');
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = chanOfStruct(Sweep,'R');
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   % store ipool in subseq 
   SD.subseq{isubs}.ipool = ipool;
   % store # heading/trailing zero samples
   SD.subseq{isubs}.Nhead = [0 0];
   SD.subseq{isubs}.Ntrail = [0 0];
   SD.subseq{isubs}.SPL = Pres.SPL;
   SD.subseq{isubs}.NREP = Pres.Nrep;
   SD.subseq{isubs}.DAmode = Pres.chan;
end; % for isubs





