function SD = stimDEFerev(SMS);

% stimDEFerev(SMS) - analyze multiplicities of SMSerev params
% and distribute action for generating different waveforms.
STIMCAT = 'erev';

Nsubseq = SMS.Nsubseq;

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
BufVar = ErevBufVar; % buffer characteristics stored in EREVnoiseX globals

for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   Tone = nthElement(SMS.TONE, isubs);
   Noise = nthElement(SMS.NOISE, isubs);
   Both = nthElement(SMS.BOTH, isubs);
   Pres = nthElement(SMS.PRES, isubs);
   % inactive channels needn't be generated
   LeftDead = isequal(Pres.chan,'R');
   RightDead = isequal(Pres.chan,'L');
   makeLeft = ~LeftDead;
   makeRight = ~RightDead;
   ipool = [0 0]; % default: no waveform
   noiseIndex = min(isubs,Pres.Ntoken); % used as noise buffer index
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = CollectInstruct(noiseIndex, Tone,Noise,Both,Pres);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = CollectInstruct(noiseIndex, Tone,Noise,Both,Pres);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   % store ipool in subseq 
   SD.subseq{isubs}.ipool = ipool;
   % store # heading/trailing zero samples
   SD.subseq{isubs}.Nhead = [0 0];
   SD.subseq{isubs}.Ntrail = [0 0];
   SD.subseq{isubs}.SPL = Pres.SPLtone*[1 1];
   SD.subseq{isubs}.NREP = Pres.Nrep;
   SD.subseq{isubs}.DAmode = Pres.chan;
end; % for isubs





