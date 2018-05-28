function Y = revcorrev(DS, icond, AnaWin, CorSpan, doPlot, DelayEstimate, Cdelay);
% revcorrev - revcor revisited
%   revcorrev(DS, icond, AnaWin, CorSpan, doPlot, DelayEstimate, Cdelay);
%   computes revcor from subsequence #icond of dataset ds.
%   Input params:
%             DS: dataset.
%          icond: selection of conditions (subsequence). If more than one
%                 is selected, the impulse responses are pooled across subseqs.
%                 A zero value means all conditions measured.
%      AnaWindow: analysis window in ms; [] means burst duration; this is 
%                 also the default. Specification of analysis window as in AnWin.
%      CorSpan: the range of times of the impulse response as a vector [t1 t2] in ms.
%                a single number t is interpreted as [0 t]. Default is [0 25].
%       doPlot: 1/0 = make plot / don't. Deafult: do plot.
%   DelayEstimate: estimate of group delay around CF. This estimate is
%                  used for optimal phase unwrapping. Default: 0 ms.
%          Cdelay: compensating delay  [ms]. Phases are advanced by cdelay
%                  to highlight details in phase curves. Default: 0 ms.
%      
%   RevCorRev returns struct Y with fields
%     Param: input parameters passed to revcorrev
%      time: time axis of impulse response
%        IR: impulse response (vector or Nx2 matrix)
%      freq: frequency axis in kHz of spectra
%   MagSpec: magnitude spectrum in dB. Estimated noise floor is set to 0 dB
%  Phase Spec: phase spectrum in cycles. Phase unwrapping optimed using 
%             DelayEstimate input parameter (see above).
%   
%
% Examples:
%    ds = dataset('C0604', '8-20-NTD');
%    Y = revcorrev(ds, 1);
%    plot(Y.time, Y.IR)
%
%    revcorrev('C0604/-23', 1)
%
%   See also RevCorPlot, AnWin.

if nargin<2, icond = 1; end % default: only first condition
if nargin<3, AnaWin = []; end % Anwin function will use burst dur
if nargin<4, CorSpan = 25; end % ms default correlation span
if nargin<5, doPlot = 1; end % do/don't plot results
if nargin<6, DelayEstimate = 0; end % ms estimate of delay used for phase unwrapping
if nargin<7, Cdelay = 0; end % ms compensating delay

if length(CorSpan)==1, CorSpan=[0 CorSpan]; end

DS = getdataset(DS); % returns dataset variable, even if DS is specified as char str (see help)
if isequal(0, icond), icond=1:DS.nrec; end % icond==0 means all recorded subseqs

% caching
CacheFileName = mfilename;
Datafile = DS.filename; seqID = DS.seqid; 
NmaxCache = 500;
% collect parameters that together uniquely determine the revcor computation
RevCorVersion = 1;
Param = CollectInstruct(RevCorVersion, Datafile, seqID, icond, AnaWin, CorSpan, DelayEstimate, Cdelay); 
Y = fromCacheFile(CacheFileName, Param);
if ~isempty(Y), % computation had been done before - just plot if rquested
    localPlot(Y, doPlot);
    return; 
end
clear Y

% isNTD = isequal('NTD', DS.stimtype);
% if isNTD, % get per-channel-delay in ms
%    delay = spkuetvar(DS);
%    delay = delay(1:DS.nrec,:); % restrict to conditions that have actually been recorded
%    delay - min(delay,[], 2)*[1 1]; % in the waveforms, delays are always positive
% end

Ncond = length(icond);
if Ncond>1, % recursive handling
   ir = 0;
   for ii=1:Ncond,
      Y = RevCorRev(DS, icond(ii), AnaWin, CorSpan);
      ir = ir + Y.IR; % sum of indiv IRs
   end
   Y.IR = ir/Ncond; % mean of all IRs
   Y.Param = Param; % override the last indiv return value by the vector-valued one
   dt = diff(Y.time([1 2])); % spacing of time axis in ms
   Y = localSpectrum(Y, dt, DelayEstimate);
   localPlot(Y, doPlot);
   return
end

% =======single condition from here==========
spt = anwin(DS, AnaWin, 0, icond); % extract spike times from DS: all reps; single condition; respect analysis window
spt = cat(2,spt{:}).'; % pool spikes across reps
[wv, dt] = stimsam(DS, icond);
dt = 1e-3*dt; % us -> ms
[time, IR] = local_compute_revcor(dt, wv, spt, CorSpan); 
Y = CollectInStruct(Param, time, IR);
Y = localSpectrum(Y, dt, DelayEstimate,Cdelay); % compute magn & phase spectrum

toCacheFile(CacheFileName, NmaxCache, Param, Y);

localPlot(Y, doPlot);


%------locals-----------------------------
function [Time, ImpulseResponse] = local_compute_revcor(dt, waveform, spiketimes, CorSpan);
% compute impulse response from stimulus & spike times using reverse correlation.
% waveform is column vector or Nx2 matrix in case of binaural stimulus.
% dt is sample period of waveform, in same units as spike times.
% CorSpan is the time range of the compted impulse response in ms.
% The spike times must be specified relative to the onset (or rather,
% the first sample) of the waveform.
Lstim = size(waveform,1); % # samples in stimulus
Nchan = size(waveform,2); % # channels
Tmean = mean(CorSpan); % offset of time of impulse response
Thalfdur = 0.5*diff(CorSpan); % half the time span of impulse response
Nmaxlag = round(Thalfdur/dt); % ~half #samples+1 in impulse response 
Nspike = length(spiketimes);
% In order to use Matlab's xcorr, convert the spike times to a "waveform", i.e., a
% PST histogram with binwidth equal to the stimulus sample period.
Swave = histc(spiketimes-Tmean, (0:Lstim)*dt)/Nspike;
% dplot(dt, Swave); pause; delete(gcf)
Swave = Swave(1:end-1); % discard the idiotic last bin (see help text of histc)
for ichan = 1:Nchan,
   ImpulseResponse(:,ichan) = xcorr(Swave, waveform(:,ichan), Nmaxlag);
end
Time = Tmean + dt*(-Nmaxlag:Nmaxlag).';

function Y = localSpectrum(Y, dt, tau_est, Cdelay); 
% compute magn & phase spectrum; max freq is 5 kHz
[nsam, nchan] = size(Y.IR);
Dur = nsam*dt; % duration in ms
df = 1/Dur; % freq spacing in kHz
TimeOffset = Y.Param.CorSpan(1); % the deviation in ms from time=zero of the first sample of the IR
Y.freq = df*(0:nsam-1).'; % freq in Hz 
% compute & apply hann window, compute complex fft spectrum
hanwin = repmat(hann(nsam),1,nchan);
Spec = fft(Y.IR.*hanwin); % complex spec after windowing
% magnitude
Y.MagSpec = a2db(abs(Spec));
[dum, ipeak] = max(Y.MagSpec); % location of spectral peak, per channel
% phase 
ang = angle(Spec); % angle in radians
%TimeOffset, tau_est, minFreq = min(Y.freq), maxFreq = max(Y.freq), df = diff(Y.freq(1:2))
ang = local_delay(ang, Y.freq, TimeOffset-tau_est); % delay/advance according to time axis of IR & estimated delay
ang = local_delay(unwrap(ang), Y.freq, tau_est-Cdelay)/2/pi; % unwrap, undo Tau estimate shift, add Cdelay, and convert to cycles
% set phase near magnitude peak to near zero cycle
ang_at_peak = [ang(ipeak(1),1) ang(ipeak(end),end)];
ang(:,1) = ang(:,1)-round(ang_at_peak(1)); 
ang(:,end) = ang(:,end)-round(ang_at_peak(end)); 
Y.PhaseSpec = ang; 
% restrict everything to freqs <= 5 kHz; use freqs>5 kHz as noise floor
iHF = find(Y.freq<=5);
if ~isempty(iHF), Y.MagSpec = Y.MagSpec - median(Y.MagSpec(iHF)); end
iLF = find(Y.freq<=5);
[Y.freq, Y.MagSpec, Y.PhaseSpec] = deal(Y.freq(iLF,:), Y.MagSpec(iLF,:), Y.PhaseSpec(iLF,:));
Y.XIR = xcorr(Y.IR(:,1),Y.IR(:,end));
Y.XIR_timeoffset = -dt*(numel(Y.XIR)-1)/2;
Y.dt = dt; Y.df = df;

function ang = local_delay(ang, freq, tau);
% delay angle vector (in rad) tau ms; freq in kHz
nchan = size(ang,2);
Shifter = -2*pi*tau*freq; % lin phase vector corresponding delay of tau 
Shifter = repmat(Shifter, 1, nchan); % adjust size to # channels
ang = ang + Shifter;

function localPlot(Y, doPlot);
% provisional plot function
if ~doPlot, return; end
subplot(2,2,1); %------IR---------
plot(Y.time, Y.IR); 
xlim([min(Y.time) max(Y.time)]); 
xlabel('Time (ms)');
ylabel('Amplitude (A.U.)');
subplot(2,2,2); %-------mag spec-----
plot(Y.freq, Y.MagSpec);
xlim([min(Y.freq) max(Y.freq)]); 
xlabel('Frequency (kHz)')
ylabel('Magnitude (dB)')
ylim([-10 10*ceil(0.1*max(Y.MagSpec(:)))]);
subplot(2,2,4); % ----phase spec-------
plot(Y.freq, Y.PhaseSpec); 
xlim([min(Y.freq) max(Y.freq)]); 
set(gcf,'position', [64 139 714 574]); 
xlabel('Frequency (kHz)')
ylabel('Phase (cycle)');
subplot(2,2,3); %----crosscorr --
%set(gca,'visible','off');
dplot([Y.dt Y.XIR_timeoffset], Y.XIR);
xlim([-10 10]);
xlabel('delay L vs R (ms)');
% colofon
awin = Y.Param.AnaWin;
if isempty(awin), awinstr = '[]'; else, awinstr = ['[' trimspace(num2str(awin)) '] ms']; end
corspan = Y.Param.CorSpan;
if isempty(corspan), cstr = '[]'; else, cstr = ['[' trimspace(num2str(corspan)) '] ms']; end
Str = strvcat([Y.Param.Datafile ' ' Y.Param.seqID ' subseq: ' paramstring(Y.Param.icond.')], ...
    ['Analysis window: ', awinstr], ...
    ['IR span: ' cstr]);
subplot(2,2,2);
text(0.7,0.8, Str, 'units', 'normalized', 'horizontalalign', 'center', 'VerticalAlignment', 'middle', 'fontsize', 8);
%
figure(gcf)
% 

