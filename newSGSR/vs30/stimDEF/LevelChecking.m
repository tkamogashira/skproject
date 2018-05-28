function SD = LevelChecking(SD, doubleCheck);

if nargin<2, doubleCheck = 0; end;

if isfield(SD,'NoLevelChecking'),
   return;
end
global noLevelCheckingPlease
if ~isempty(noLevelCheckingPlease),
   warning('level checking cancelled');
   return;
end
global SGSR
SHARERANGE = 12; % dB ~ 2 D/A bits unused in worst case

Nwf = length(SD.waveform);
Nsub = length(SD.subseq);

% first collect desired levels of each waveform by visiting all subseqs
wantedLevels = cell(1, Nwf);
wantedBy = cell(1, Nwf);
for isubs = 1:Nsub,
   for ichan=1:2,
      ipool = SD.subseq{isubs}.ipool(ichan);
      if ipool>0,
         SPL = SD.subseq{isubs}.SPL(ichan);
      	wantedLevels{ipool} = [wantedLevels{ipool} SPL];
         wantedBy{ipool} = [wantedBy{ipool} [isubs; ichan]];
      end;
   end;
end


% now analyze per waveform if levels are doable and if 
% numerical attenuation is needed.
prefMinNumAtt = -a2db(SGSR.prefDAfraction); % preferred minimum numerical att 
numAtten = cell(1,Nwf);
anaAtten = cell(1,Nwf);
for iwf = 1:Nwf,
   maxSPL = SD.waveform{iwf}.DAdata.MaxSPL;
   % compute total attenuation needed to realize desired levels
   totalAtten = maxSPL - wantedLevels{iwf}; 
   if any(totalAtten<0),
      toolarge = find(totalAtten<0);
      sslist = num2str(wantedBy{iwf}(1,toolarge));
      error(['excessive levels of subsequences: ' sslist]);
   end
   % split total attenuation in analog and numerical part
   anaAtten{iwf} = min(totalAtten,maxAnalogAtten);
   numAtten{iwf} = totalAtten - anaAtten{iwf};
   % if several numerical attenuations are needed that
   % differ only a little, a host of basically identical waveforms
   % could be generated. To avoid this, round the num attenuations
   % so that subsequences that are close in level are played
   % from the same waveform. Be sure that num attenuations are rounded
   % *up* so that we don't get into trouble with analog attenuations
   % becoming too high.
   minNumAtt = min(numAtten{iwf});
   numAtten{iwf} = minNumAtt ...
      + SHARERANGE * ceil((numAtten{iwf} - minNumAtt)/SHARERANGE);
   % adjust anaAtten so that the sum equals total attenuation needed
   anaAtten{iwf} = totalAtten - numAtten{iwf};
   % finally, we incorporate the notion of "preferred minimal numerical attenuation:"
   % if possible, we want to use some baseline numerical attenuation to 
   % keep out of the max peak2peak voltage of the DAC, because high voltages 
   % are likely to give more distortion. So we will try to move a certain
   % portion of the analog attenuation to the numerical attenuation - if
   % possible (for very intense sounds, it is not).
   AttToMove = prefMinNumAtt - numAtten{iwf}; % portion of att to move from ana to num, ideally
   AttToMove = max(AttToMove,0); % % moveAtt must be positive
   AttToMove = min(AttToMove,anaAtten{iwf}); % it cannot exceed anaAtten
   % move the computed portions fro mana to num
   anaAtten{iwf} = anaAtten{iwf} - AttToMove;
   numAtten{iwf} = numAtten{iwf} + AttToMove;
end % for iwf
%'---anaAtten--'
%anaAtten{:}
%'---numAtten--'
%numAtten{:}
%'---wantedLevels--'
%wantedLevels{:}
%'---wantedBy--'
%wantedBy{:}

% now visit the waveforms again, look which subseqs need them,
% and for each of those subseqs: (1) if this is the first subseq
% that uses this waveform, it gets it and the numerical num atten is
% adjusted to serve that subsequence (2) for subsequent subsequences, 
% first look if a copy of the original waveform exists that has
% the correct num atten for the subsequence at hand. If so, tell the subseq 
% to use that waveform (3) if no fitting waveform copy exists,
% generate it and appoint it to the subsequence at hand.
% in all cases, store the analog attenuation in the subsequence
% in channelwise manner.
% Note: MaxSPL field and amplitude description in GENdata
% struct of waveforms always describes the amplitude as if no numerical
% attenuation were present, i.e., numerical attenuation
% is treated as an "after-the-fact" manipulation.
% It is also treated as such in the stimgen functions like stimgensxm.
NnewWF = 0; % number of newly generated waveforms (=copies with different num attenuation)
for iwf = 1:Nwf,
   subseqs = wantedBy{iwf}(1,:); % all subsequences that use waveform{iwf}
   channel = wantedBy{iwf}(2,:); % the respective channels they need it for
   % now visit all these subsequences that need the current waveform
   for ii=1:length(subseqs), % ii is index of the 4 book-keeping variables below; ...
      % ... it counts the subsequences that need the current waveform (see above).
      isubseq = subseqs(ii); % current subseq index
      ch = channel(ii); % channel of subseq that uses waveform{iwf}
      currentNumAtt = numAtten{iwf}(ii); % numerical atten for the current subseq
      currentAnaAtt = anaAtten{iwf}(ii); % analog atten for the current subseq
      if ~isfield(SD.subseq{isubseq},'AnaAtten'),
         SD.subseq{isubseq}.AnaAtten = [1 1]*maxAnalogAtten; % initialize as 1x2 vector
      end
      if ii==1, % the first subseq encountered gets the original waveform it already had
         % store num atten, and channel that has the current num att
         SD.waveform{iwf}.GENdata.numAtt = currentNumAtt;
         % remember the num att info of current waveform so that other subseqs can share it
         numAttRealized = [currentNumAtt; isubseq; ch]; 
      else, % look if waveform copy with correct numatt has been realized before
         correctCopy = find(currentNumAtt==numAttRealized(1,:));
         if ~isempty(correctCopy), % we can use an existing waveform
            stealFrom = correctCopy(1); % col index of earlier copy in numAttRealized
            EarlierIsubseq = numAttRealized(2,stealFrom); % index of earlier subseq 
            EarlierChan = numAttRealized(3,stealFrom); % channel of earlier subseq
            waveformIndex = SD.subseq{EarlierIsubseq}.ipool(EarlierChan);
            % attach this earlier waveform to current subseq
            SD.subseq{isubseq}.ipool(ch) = waveformIndex;
         else, % no correct copy found; generate a new one
            % the originally attched waveform is okay save for its numerical attenuation:
            copyFrom = SD.subseq{isubseq}.ipool(ch);
            NnewWF = NnewWF + 1; % counts number of newly generated (copied) waveforms
            % copy the original waveform
            CopyTo = Nwf+NnewWF; % first unused waveform index
            SD.waveform{CopyTo} = SD.waveform{copyFrom}; % new waveform is identical ...
            % ... except for numerical attenuation:
            SD.waveform{CopyTo}.GENdata.numAtt = currentNumAtt;
            % sign the contribution 
            SD.waveform{CopyTo}.GENdata.createdby = ...
               [SD.waveform{CopyTo}.GENdata.createdby '; ' mfilename];
            % attach this new waveform to current subseq 
            SD.subseq{isubseq}.ipool(ch) = CopyTo;
            % finally, report the arrival of this new copy so that it can be re-used
            numAttRealized = [numAttRealized, [currentNumAtt; isubseq; ch]]; 
         end % if ~isempty(correctCopy)
      end % if ii==1
      % store analog attenuation of the current channel of the current subseq
      SD.subseq{isubseq}.AnaAtten(ch) = currentAnaAtt;
   end % subseq loop
end % iwf loop

if doubleCheck,
   local_DoubleCheckLevels(SD);
end
%---------locals----------------------
% testing the levels
function local_DoubleCheckLevels(SD);
Nsub = length(SD.subseq);
DEV = 0;
for isubseq=1:Nsub,
   wantedLevel = SD.subseq{isubseq}.SPL;
   realizedLevel = [1 1]*NaN;
   for ichan=1:2,
      iwf = SD.subseq{isubseq}.ipool(ichan);
      if iwf~=0,
         maxSPL = SD.waveform{iwf}.DAdata.MaxSPL;
         numAtten = SD.waveform{iwf}.GENdata.numAtt;
         anaAtten = SD.subseq{isubseq}.AnaAtten(ichan);
         realizedLevel(ichan) = maxSPL-numAtten-anaAtten;
      end
   end
   DEV = DEV + mean((realizedLevel-wantedLevel).^2);
end
DEV = DEV^0.5;
if DEV>1e-3,
   warning(['deviations in level adjustment: DEV = ' num2str(DEV)]);
end










