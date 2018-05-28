function SD = stimDEFnoise(SMS);

% stimDEFnoise(SMS) - analyze multiplicities of SMSnoise params
% and distribute action for generating different waveforms.
STIMCAT = 'noise';

% make sure global NoiseBuffer is initialized
[dummy1 dummy2] = gaussNoiseBand(SMS.NoiseParams); 
% Note: if gaussNoiseBand had been called before...
% .. with identical params, it wasts no CPU

Nsubseq = SMS.Nsubseq;

% ITD-like stimulus menus are possible exceptions in that the number
% of stimulus ITDs is not necessarily equal to the number
% waveforms, as different ITDs can be realized by heading and 
% trailing zeros around identical waveforms. 
ITDsaving = SMS.SD_INSTR.ITDsaving;
ITD = SMS.TIMING.totalITD;
if ITDsaving,
   % find out for each subseq, which subseq is the first to have
   % a certain wavITD
   ITDancienity = firstIndexWithValue(ITD.wavITD);
   Nhead = ITD.Nhead; 
else, % no heading or trailing zero samples when playing waveforms
   Nhead = zeros(Nsubseq,2);
end
% trailing zero samples to make each playing of waveform last equally long
Ntrail = max(max(Nhead)) - Nhead;
% extra time needed for heading/trailing zeros (needed for checking repDur)
samP = 1e6/SMS.NoiseParams.Fsample; % sample period in us
ExtraTime = max(max(Nhead))*samP*1e-3; % in ms

% variation of left and right channels indivually
LeftConstant = SMS.SD_INSTR.LeftConstant;
RightConstant = SMS.SD_INSTR.RightConstant;

% in which channel is the ITD expressed?
ITDchan = SMS.SD_INSTR.ITDchan;

OneWaveformPair = LeftConstant & RightConstant;

% waveform ITDs  are realized by 
% using multiple waveforms in only one
% channel (figured out above).
% Modify the onsets accordingly and increase the total
% duration so that the burst will always fit.
% Note: positive ITD means right-channel lead
minITD = min(ITD.wavITD); 
maxITD = max(ITD.wavITD);
if isequal(ITDchan,'LEFT'),
   Head = 1e-3*max(0, -minITD); % heading sil in ms of left chan
   Tail = 1e-3*max(0, maxITD); %trailing silence in ms of left chan
   SMS.TIMING.onset = Head + kron(1e-3*ITD.wavITD, [1 0]);
elseif isequal(ITDchan,'RIGHT'),
   % same thing with right and left channels interchanged and
   % sign change in totalITD
   Head = 1e-3*max(0, maxITD);% heading sil in ms of right chan
   Tail = 1e-3*max(0, -minITD);%trailing silence in ms of left chan
   SMS.TIMING.onset = Head - kron(1e-3*SMS.BIN.waveformITD,[0 1]);
end;
SMS.TIMING.totDur = SMS.TIMING.burstDur + Head + Tail; % burst dur plus space to move
% increase repDur if totDurs do not fit
repDur = SMS.TIMING.repDur; % might be column vector
repDur = max(repDur, SMS.TIMING.totDur(:,1)+ExtraTime); % left channel
repDur = max(repDur, SMS.TIMING.totDur(:,2)+ExtraTime); % right channel

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
global NoiseBuffer % here the noise sample are stored by the last call to GaussNoiseBand
if iscell(NoiseBuffer.NoiseStruct), NoiseBufferIndex = 1:Nsubseq; % multiple noise buffers
else, NoiseBufferIndex = zeros(1,Nsubseq); % unique noise buffer
end
for isubs=1:Nsubseq,
   % presentation & timing params for this subsequence only
   PRES = nthElement(SMS.PRES, isubs);
   Timing = nthElement(SMS.TIMING, isubs);
   if NoiseBufferIndex==0, NoiseParams = NoiseBuffer.StimParams;
   else, NoiseParams = NoiseBuffer{isubs}.StimParams;
   end
   % is a new wave form needed? Evaluate per channel
   makeLeft = ~LeftConstant | (isubs==1);
   makeRight = ~RightConstant | (isubs==1);
   if ITDsaving,
      % only generate new waveform if waveformITD(isubs) is new
      if isequal(ITDchan,'LEFT'),
         makeLeft = isequal(isubs,ITDancienity(isubs));
      elseif isequal(ITDchan,'RIGHT'),
         makeRight = isequal(isubs,ITDancienity(isubs));
      end
   end;
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
      SD.waveform{Nwf}.stimpar = CombineStruct(NoiseParams, chanOfStruct(Timing,'L'));
      SD.waveform{Nwf}.stimpar.NoiseBufferIndex = NoiseBufferIndex(isubs);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = CombineStruct(NoiseParams, chanOfStruct(Timing,'R'));
      SD.waveform{Nwf}.stimpar.NoiseBufferIndex = NoiseBufferIndex(isubs);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(2) = Nwf;
   end;
   % correct zero pool values for active channels
   % Note: order of logical expressions below is important because, 
   % by convention, the left channel takes the burden of generating
   % waveforms in case of diotic signals. The right channel will then 
   % be able to steal from the right one, but not vice versa.
   if ~LeftDead,
      if isequal(ipool(1),0),
         if LeftConstant, % steal from previous subseq
            ipool(1) = SD.subseq{isubs-1}.ipool(1);
         elseif ITDsaving & isequal(ITDchan,'LEFT'), % steal from ancient waveform
            ipool(1) = SD.subseq{ITDancienity(isubs)}.ipool(1);
         end
      end
   end
   if ~RightDead,
      if isequal(ipool(2),0),
         if RightConstant, % steal from previous subseq
            ipool(2) = SD.subseq{isubs-1}.ipool(2);
         elseif ITDsaving & isequal(ITDchan,'RIGHT'), % steal from ancient waveform
            ipool(2) = SD.subseq{ITDancienity(isubs)}.ipool(2);
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





