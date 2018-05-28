function y=TCurveplayRecord;
% synched play with adaptive loop for tuning curves

global PRPinstr SGSR SpikeSim PRPstatus TcurveThreshold TcurveFreq
simul = ~isempty(SpikeSim);
N = length(PRPinstr.PLAY);

%--------SPONTANEOUS ACTIVITY-------
% empty ET1 buffer and previously stored spikes
initSpikeRec; % initializes global SPIKES struct in which events are stored
% open or refresh plot
PlotFnc = [PRPinstr.PLOT.PlotType 'Plot'];
closeStimMenu(feval(PlotFnc, 'init')); % plot will die with stim menu
secureET1clear;
% initialize report function
subSeqDur = PRPinstr.PLAY(1).Nplay*1e-3*PRPinstr.PLAY(1).SamP; %in ms
ReportProgress('init', subSeqDur(1));

% use standard synched player - no adaptive stuff yet
playit(PRPinstr.PLAY(1), 1); % second arg: do record
ReportProgress('play', 1);
localTinyDelay('init');
while (s232('PD1status',1)~=0),
   GetSpikesFromET1; % we're waiting for D/A anyhow
   drawnow;
end
if localStopRequested,
   UIinfo('User interrupt during silent interval',[],textRed);
   return;
end
et1go; et1stop; % end-of-subseq marker & stop
ss1switching('N',1,1); % disconnnect D/A and ET1
GetSpikesFromET1; % last few spikes
minimizeSpikes; % reduce size of global SPIKES to  just fit the data
% analyze the spont activity and resulting treshold spike count
[meanCount Sigma CritNspike] = ...
   local_AnaSpont(PRPinstr.RECORD(1), PRPinstr.Adapt.Track, simul);
[SRinfo, Ptitle] = localSRinfoStrings(meanCount, Sigma, CritNspike);
UIinfo(SRinfo);
TcurvePlot('title',Ptitle);
PRPstatus.SpikesStored = 1;
%----------VISIT ALL FREQS & PERFORM ADAPTIVE TRACKING-------------
Track = PRPinstr.Adapt.Track;
Freq = PRPinstr.PLOT.varValues(2:end);
TcurveFreq = Freq;
TcurveThreshold = repmat(NaN,N-1,1); % NaN initialization needed for evaluation of start values
startSPL = TcurveThreshold;
for isub=2:N, ifreq = isub-1;
   UIinfo(strvcat(SRinfo,[num2str(round(Freq(ifreq))) ' Hz   ' ...
         num2str(ifreq)  '/' num2str(N-1) ]));
   drawnow;
   if localStopRequested,
      UIinfo('User interrupt',[],textRed);
      return;
   end
   % prepare hardware (PD1, ET1)
   localPrepareDA(PRPinstr.PLAY(isub));
   % collect params for this particular adaptive run
   maxSPL = PRPinstr.Adapt.MaxSPL(ifreq);
   SilChan = 1; % PRPinstr.Adapt.SilChan(ifreq);
   SilDBN = PRPinstr.Adapt.SilDBN(ifreq);
   startSPL(ifreq) = ...
      localStartVal(Freq, TcurveThreshold, [Track.minSPL Track.maxSPL], Track.startSPL, ifreq);
   maxNrep = PRPinstr.RECORD(isub).Nrep;
   repDur = PRPinstr.RECORD(isub).repDur;
   % acceptance windows for spike count
   Onsets = PRPinstr.RECORD(isub).switchDur+(0:maxNrep-1)*PRPinstr.RECORD(isub).repDur;
   Offsets = Onsets+(PRPinstr.RECORD(isub).repDur-PRPinstr.RECORD(isub).repsilDur);
   AcceptWin = 1e3/SGSR.ClockRatio*[Onsets; Offsets]; % ms->us(PD1)->us(ET1)
   if simul, localSimulSpikeCount('init',isub); end
   % initialize adaptive track
   tctrack('init',ifreq,[1 1 5 4], [startSPL(ifreq) Track.minSPL Track.maxSPL], ...
      [Track.stepSize*[2 1]; [2 Track.Nrev]], maxNrep);
   curSPL = startSPL(ifreq);
   localDAgo(PRPinstr.PLAY(isub)); % this includes switching from sync to D/A
   % read synched pulse from buffer TCspikeCount will empty buffer & destroy this info
   syncTime = localGetSyncTime;
   if isnan(syncTime), UIerror('Problem retrieving sync pulse from ET1'); return; end;
   for irep=1:maxNrep,
      localTinyDelay;
      % curSPL
      setPA4s(maxSPL-curSPL);
      % wait till tone is being played
      if localWaitForNotSil(SilDBN,SilChan), break; end; % break if D/A stopped
      if localWaitForSil(SilDBN,SilChan), break; end; % break if D/A stopped
      % collect spike info
      Nspike = TCspikeCount(AcceptWin(:,irep)+syncTime, CritNspike);
      if simul, Nspike=localSimulSpikeCount(curSPL, repDur); end
      curSPL = tctrack(Nspike>=CritNspike,ifreq);
      if isnan(curSPL), break; end;
      if PRPstatus.interrupt, break; end;
   end
   completeStop2;
   setPA4s(maxAnalogAtten);
   if PRPstatus.interrupt, break; end;
   TcurveThreshold(ifreq) = localThresholdFromTrack(tctrack('result',ifreq));
   TcurvePlot(ifreq, TcurveThreshold(ifreq)); 
   TcurvePlot('draw'); 
   localWaitForSil(SilDBN,SilChan);
   localTinyDelay;
   setPA4s(maxAnalogAtten);
end % for isub=2:N


tcurveplot('finish');
hold on
if isdeveloper,
   plot(Freq, startSPL,'om');
end
if simul,
   hold on;
   plot(Freq, SpikeSimFun(Freq),'xr')
end

%-----LOCALS-----------------------
%----------------------------------
function endOfDA = localWaitForSil(DBNsil, ch);
% waits until DA is from DBNsil DAMA buffer or D/A is stopped
% optimized for speed (playseg is much faster than PD1status; also
% no hurry when D/A is stopped)
endOfDA = 0;
for jjj=0:inf,
   for iii=1:100, 
      if (s232('playseg',ch)==DBNsil), 
         break; 
      end; 
   end;
   if (s232('playseg',ch)==DBNsil), break; end;
   if (s232('PD1status',1)==0), endOfDA = 1; break; end;
end
%-----------------------------------
function endOfDA = localWaitForNotSil(DBNsil, ch);
% waits until DA is not from DBNsil DAMA buffer or until D/A is stopped
% see localWaitForSil above
endOfDA = 0;
for jjj=0:inf,
   for iii=1:100, 
      if (s232('playseg',ch)~=DBNsil), 
         break; 
      end; 
   end;
   if (s232('playseg',ch)~=DBNsil), break; end;
   if (s232('PD1status',1)==0), endOfDA = 1; break; end;
end
%-----------------------------------
function [meanCount, Sigma, critNspike]=local_AnaSpont(rec, trac, simul);
global SGSR
switchDur = rec.switchDur; % exact switch time in ms
% get spike time re stim onset, in ms according to PD1
if simul, spt = localSimSpont(rec);
else, spt = SGSR.ClockRatio*1e-3*getSpikeTimes(1) - switchDur;
end
% divide in bins
BINS = (0:rec.Nrep)*rec.repDur;
if isempty(spt), NSP = 0*BINS;
else, NSP = histc(spt, BINS);
end
% binWidth = BINS(2)-BINS(1);
% figure; bar(BINS+0.5*binWidth, NSP); xlabel('time interval (ms)'); ylabel('Spike count');
NSP = sort(NSP(1:end-1)); % remove on-the-edge count
% throw away outliers due to sound
Naway = round(rec.Nrep/10);
NSP = NSP(Naway+1:end-Naway);
meanCount = mean(NSP);
Sigma = std(NSP)/0.66; % compensate for removal of outliers (correct for gaussian distr)
% now compute # spikes that constitutes the supra-threshold criterium
switch trac.critMode
case 'spike'
   critNspike = meanCount + trac.critVal;
case 'perc'
   critNspike = meanCount(1 + 1e-2*trac.critVal);
case 'std'
   critNspike = meanCount + Sigma*trac.critVal;
case 'sqrt'
   critNspike = meanCount + sqrt(meanCount)*trac.critVal;
end
critNspike = floor(critNspike);
% critNspike must be at least one spike above median rate
critNspike = max(critNspike, 1+floor(meanCount)); 

function SR=localStopRequested;
global PRPstatus
SR = PRPstatus.interrupt;

function SV = localStartVal(freqs, oldVal, limVal, defStartVal, newIndex);
% returns reasonable start value based on previous values
% using a spline. Hard upper limit and default start values are respected.
% oldVal must contain all values, NaN's are undetermined yet
minVal = min(limVal); maxVal = max(limVal);
% sort everything according to frequency
[dummy, sortIndex] = sort(freqs);
oldVal = oldVal(sortIndex);
XX = 1:length(oldVal);
newIndex = find(newIndex==sortIndex);
% find three nearest values
Det = find(~isnan(oldVal));
XX = XX(Det);
oldVal = oldVal(Det);
[klomst, near] = sort((XX-newIndex).^2);
near = near(1:min(4,length(near)));
XX = XX(near);
oldVal = oldVal(near);
switch length(oldVal);
case 0, SV = defStartVal;
case 1, SV = oldVal;
otherwise, 
   globs = polyfit(XX(:),oldVal(:),1);
   SV = polyval(globs, newIndex);
end
SV = min(SV,maxVal);
SV = max(SV,minVal);

function localPrepareDA(playInstr);
% prepares hardware to the point of final D/A GO
PrepareHardware4DA(playInstr.Hardware); 
% load playlist(s) to dama, and issue seqplay command
loadPlayList(playInstr);
s232('seqplay', playInstr.chanDBN);
% prepare hardware up to final D/A go
s232('PD1arm',1); 
ET1clear; SecureET1go; % must be started before D/A or else will miss click

function localDAgo(playInstr);
s232('PD1go',1);
% ----swift rewiring for proper sound output and spike input
% connect ET1 to spike trigger device, etc.
% already figured out in function ss1switching called by playINSTR.
for icomm=playInstr.Hardware.postGo.', % column-wise assignment (see help for)
   s232('SS1select', icomm(1), icomm(2), icomm(3));
end;

function ST = localGetSyncTime;
% must be called after a sequence ET1CLEAR - ET1GO - synch pulse to ET1
MaxWait = 1e3; % ms max waiting time
ST = NaN;
tic;
while 1,
   for i=1:1000,
      if ET1report>=2, break; end
   end
   if ET1report>=2, break; end
   if 1e3*toc>MaxWait, return; end
end
stamp1 = s232('ET1read32',1);
if stamp1~=0, error('ET1GO not processed properly'); end
ST = s232('ET1read32',1);

function ST = localTinyDelay(cal, DEL);
% a 45-ms delay is needed when using playseg; it runs ahead?!
persistent N
if isempty(N) & (nargin<1), error('TinyDelay func not calibrated'); end;
if isempty(N),  % must use dedicated call for calibr
   if nargin<2, DEL = 45; end;
   NN = 5e4; tic; for ii=1:NN, cos(23); end;
   dt = toc/NN;
   N = round(DEL*1e-3/dt);
end
for iii=1:N, cos(23); end 

function spt = localSimSpont(rec)
% simulate spontaneous response
global SGSR SpikeSim
TotDur = rec.Nrep*rec.repDur; % total duration in ms of silent interval
Nexp = SpikeSim.SpontRate*TotDur*1e-3; % expected (mean) # spikes
N = gpoisson(Nexp); % true number of spikes
% spikes are randomly distributed over Dur
spt = TotDur*rand(1,N);

function N = localSimulSpikeCount(curSPL, isub);
persistent freq
global SpikeSim
if isequal(curSPL, 'init'),
   global PRPinstr
   freq = PRPinstr.PLOT.varValues(isub);
   % get parameters of i/o function for current freq
   [Thr, Slope] = SpikeSimFun(freq);
   % initialize input-output function
   inputOutput(nan, SpikeSim.SpontRate, Slope, 5 ,Thr, 300);
   return
end
% routine call: return # spikes
Nexp = 1e-3*isub*inputOutPut(curSPL);
N = gpoisson(Nexp);

function thr = localThresholdFromTrack(TR);
switch TR.EndReason
case 'Nrev'
   Nav = 2*floor(TR.NRevStep(end)/2); % # reversals to average over
   revIndex = find(TR.Rev)-1;
   avIndex = revIndex(end-Nav+1:end); % indeices of last Nav reversals
   thr = mean(TR.AllVal(avIndex));
case 'Nceil'
   thr = TR.MaxVal;
case 'Nfloor'
   thr = TR.MinVal;
case 'Nrun'
   thr = NaN;
otherwise,
   thr = TR.MaxVal;
end

function [SRinfo, Ptitle] = localSRinfoStrings(meanCount, Sigma, CritNspike);
global PRPinstr
meanRate = meanCount*1e3/PRPinstr.RECORD(1).repDur;
MCstr = num2str(meanCount,3);
SGstr = num2str(Sigma,3);
MRstr = num2str(meanRate,3);
CNstr = num2str(CritNspike);
SRinfo = strvcat('Spontaneous activity:',...
   [MCstr ' +/- ' SGstr ' sp/burst (~' MRstr  ' sp/s)'],...
   ['threshold spike count: ' CNstr ' sp/burst']);
Ptitle = ['SR=' MCstr '+/-' SGstr ' sp/b (' MRstr 'sp/s); CRIT='  CNstr 'sp/b'];

