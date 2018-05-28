function [BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, chan] = ExtractSpecialParams(pp);
% ExtractSpecialParams - extract special parameters from stimulus parameter struct
if nargout<2, % return struct
   [BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, chan] = ExtractSpecialParams(pp);
   RepDur = nan;
   BurstDur = CreateSpecialVarStruct(...
      RepDur, BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, chan);
   return;
end

% default value: NaN means not  applicable
BurstDur = NaN;
CarFreq = NaN;
ModFreq = NaN;
BeatFreq = NaN;
BeatModFreq = NaN;

try, stimname = upper(pp.Header.StimName);
catch, stimname = upper(IDFstimname(pp.stimcntrl.stimtype));
end

if isPDP11compatible(stimname),
   Tones = {'FS' 'SPL', 'IID', 'ITD' 'BB', 'IMS', 'FSLOG' 'BFS' 'LMS' 'BMS'}; % SXM stimcat
   ClickTrains = {'CFS' 'CSPL'};
   Noises = {'NTD' 'NSPL'};
   chan = pp.stimcntrl.activechan;
   if chan==0, chans=[1 2]; else, chans = chan; end;
   % -----------burst duration: max of the duration(s) of the individual active channels.
   switch stimname,
   case Tones, % use SMS to sort things out
      SMS = IDF2SMS(pp); 
      % public(SMS); disp(['------' mfilename]);
      ord = SMS.PRP.playOrder;
      BurstDur = [SMS.LEFT.burstDur SMS.RIGHT.burstDur];
      BurstDur = BurstDur(chans);
   case ClickTrains, % same trick, other names
      SMS = IDF2SMS(pp);
      ord = SMS.PRP.playOrder;
      BurstDur = SMS.TIMING.burstDur;
      BurstDur = BurstDur(chans);
   case Noises,
      BurstDur = localIDFget(pp, 'duration', chan);
   case {'FM'},
      BurstDur = localIDFget(pp, 'sweepup', chan) + ...
         localIDFget(pp, 'sweephold', chan) + ...
         localIDFget(pp, 'sweepdown', chan); 
   case {'???'}
      BurstDur = localIDFget(pp, 'duration', chan);
   end
   % --------carrier freqs-----------
   switch stimname,
   case Tones, % SMS was computed above
      CarFreq = [SMS.LEFT.carFreq SMS.RIGHT.carFreq];
      CarFreq = localFIXorder(CarFreq, ord, chans);
   case ClickTrains, % same trick, other names
      CarFreq = SMS.FREQ.pulseFreq;
      CarFreq = localFIXorder(CarFreq, ord, chans);
   end
   % -----------modulation freqs-----------
   switch stimname,
   case Tones, % SMS was computed above
      ModFreq = [SMS.LEFT.modFreq SMS.RIGHT.modFreq];
      ModFreq = localFIXorder(ModFreq, ord, chans);
   end
   % -----------Beat freqs: convention is FreqRight-FreqLeft-----------
   BeatFreq = CarFreq(:,end)-CarFreq(:,1); % single channel-> all zeros
   BeatModFreq = ModFreq(:,end)-ModFreq(:,1); % single channel-> all zeros
else, % non-Farmington data
   chan = pp.Header.StimParams.active;
   if chan==0, chans=[1 2]; else, chans = chan; end;
   switch stimname,
   case 'WAV',
      wdet = pp.Header.StimParams.WAVdetails;
      BurstDur = localFIXorder(wdet.Durations, pp.Header.PlayOrder, chan);
   case 'THR',
      BurstDur = pp.Header.StimParams.burstDur;
      RepDur = pp.Header.StimParams.interval;
      CarFreq = pp.Header.StimParams.cfreqs;
   case 'ARMIN',
      BurstDur = pp.Header.StimParams.burstDur;
   case 'BN',
      BurstDur = floor(min(pp.Header.repDur));
   end % switch stimname
   
end

%--------------
function x=localIDFget(idf,fn,act);
if act==0, act = [1 2]; end;
try % indiv fields
   x = [getfield(idf.indiv.stim{1},fn), getfield(idf.indiv.stim{2},fn)];
   x = x(act);
catch % stimcmn
   x = getfield(idf.indiv.stimcmn,fn);
   x = x+0*act; % correct size
end

function x=localFIXorder(x,order,act);
if size(x,1)>1, x = x(order, :); end;
if size(x,2)>1, x = x(:,act);
elseif act==0, x = [x x];
end



