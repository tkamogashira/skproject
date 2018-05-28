function SD = stimDEFsxm(SMS);

% stimDEFsxm(SMS) - analyze multiplicities of SMSsxm params
% and distribute action for generating different waveforms.
STIMCAT = 'sxm';

Nsubseq = SMS.Nsubseq;

% ITD-like stimulus menus are possible exceptions in that the number
% of stimulus ITDs is not necessarily equal to the number
% waveforms, as different ITDs can be realized by heading and 
% trailing zeros around identical waveforms. 
ITDsaving = SMS.SD_INSTR.ITDsaving;
if ITDsaving,
   % find out for each subseq, which subseq is the first to have
   % a certain ITD
   ITDancienity = firstIndexWithValue(SMS.BIN.waveformITD(SMS.BIN.ITDindex));
   Nhead = SMS.BIN.Nhead; 
else, % no heading or trailing zero samples when playing waveforms
   Nhead = zeros(Nsubseq,2);
end
% trailing zero samples to make each playing of waveform last equally long
Ntrail = max(max(Nhead)) - Nhead;

% variation of left and right channels indivually
LeftConstant = SMS.SD_INSTR.LeftConstant;
RightConstant = SMS.SD_INSTR.RightConstant;

% in which channel is the ITD expressed?
ITDchan = SMS.SD_INSTR.ITDchan;

OneWaveformPair = LeftConstant & RightConstant;
if OneWaveformPair, % pick the most critical tolerance
   SMS.LEFT.carTol = sign(SMS.LEFT.carTol).*min(abs(SMS.LEFT.carTol));
   SMS.RIGHT.carTol = sign(SMS.RIGHT.carTol).*min(abs(SMS.RIGHT.carTol));
   SMS.LEFT.modTol = sign(SMS.LEFT.modTol).*min(abs(SMS.LEFT.modTol));
   SMS.RIGHT.modTol = sign(SMS.RIGHT.modTol).*min(abs(SMS.RIGHT.modTol));
end

% waveform ITDs  are realized by 
% using multiple waveforms in only one
% channel (figured out above).
% Modify the onsets accordingly and increase the total
% duration so that the burst will always fit.
% Note: positive ITD means right-channel lead
if isequal(ITDchan,'LEFT'),
   minITD = min(SMS.BIN.waveformITD); 
   maxITD = max(SMS.BIN.waveformITD);
   LeftHead = 1e-3*max(0, -minITD);% heading sil in ms of left chan
   LeftTail = 1e-3*max(0, maxITD);%trailing silence in ms of left chan
   SMS.LEFT.onset = LeftHead + 1e-3*SMS.BIN.waveformITD;
   SMS.LEFT.totDur = SMS.LEFT.burstDur + LeftHead + LeftTail;
   SMS.RIGHT.onset = LeftHead;
   SMS.RIGHT.totDur = SMS.RIGHT.burstDur + SMS.RIGHT.onset;
elseif isequal(ITDchan,'RIGHT'),
   % same thing with right and left channels interchanged and
   % sign change in totalITD
   minITD = min(-SMS.BIN.waveformITD); 
   maxITD = max(-SMS.BIN.waveformITD);
   RightHead = 1e-3*max(0, -minITD);% heading sil in ms of left chan
   RightTail = 1e-3*max(0, maxITD);%trailing silence in ms of left chan
   SMS.RIGHT.onset = RightHead - 1e-3*SMS.BIN.waveformITD;
   SMS.RIGHT.totDur = SMS.RIGHT.burstDur + RightHead + RightTail;
   SMS.LEFT.onset = RightHead;
   SMS.LEFT.totDur = SMS.LEFT.burstDur + SMS.LEFT.onset;
end;
% increase repDur if totDurs do not fit
SMS.MON.repDur = max(SMS.MON.repDur, SMS.LEFT.totDur);
SMS.MON.repDur = max(SMS.MON.repDur, SMS.RIGHT.totDur);

SD.subseq = cell(1,Nsubseq);
Nwf = 0; % waveform counter
for isubs=1:Nsubseq,
   % avoid slow, recursive, calls to nthelement
   % so split up instead of SMSi = ntheElement(SMS)
   SMSi.LEFT = nthElement(SMS.LEFT, isubs);
   SMSi.RIGHT = nthElement(SMS.RIGHT, isubs);
   SMSi.BIN = nthElement(SMS.BIN, isubs);
   SMSi.MON = nthElement(SMS.MON, isubs);
   % is a new wave form needed? Evaluate per channel
   LeftDead = isequal(SMSi.BIN.chan,'R');
   RightDead = isequal(SMSi.BIN.chan,'L');
   makeLeft = ~LeftConstant | (isubs==1);
   makeLeft = makeLeft & ~LeftDead;
   makeRight = ~RightConstant | (isubs==1);
   makeRight = makeRight & ~RightDead;
   if ITDsaving,
      % only generate new waveform if waveformITD(isubs) is new
      if isequal(ITDchan,'LEFT'),
         makeLeft = isequal(isubs,ITDancienity(isubs));
      elseif isequal(ITDchan,'RIGHT'),
         makeRight = isequal(isubs,ITDancienity(isubs));
      end
   end;
   ipool = [0 0]; % default: no waveform
   if makeLeft,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'L';
      SD.waveform{Nwf}.stimpar = ...
         combineStruct(SMSi.MON, SMSi.LEFT);
      SD.waveform{Nwf}.stimpar.createdby = mfilename;
      ipool(1) = Nwf;
   end;
   if makeRight,
      Nwf = Nwf + 1;
      SD.waveform{Nwf}.stimCat = STIMCAT;
      SD.waveform{Nwf}.channel = 'R';
      SD.waveform{Nwf}.stimpar = ...
         combineStruct(SMSi.MON, SMSi.RIGHT);
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
   SD.subseq{isubs}.SPL = nthElement(SMS.SPL, isubs);
   SD.subseq{isubs}.NREP = nthElement(SMS.NREP, isubs);
   DAmode = SMSi.BIN.chan; % here 'B' means Both, which can ..
   % ... either imply binaural ('B') or diotic ('D').
   SD.subseq{isubs}.DAmode = DAmode;
end; % for isubs





