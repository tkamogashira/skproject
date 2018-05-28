function Y = apple(varargin);
% APPLE - processing of Zwuis data in phase-locking regime
%   usage: apple(iseq, cdelay, YLIMphase, YLIMamp)

%disp('=========================')
%varargin{:}
%disp('=========================')
persistent AppleLastMedianPhase

more off;
RC = 0.001; % criterium for Rayleigh significance
RCcr = 0.01; % idem, hard criterium 
curco = 'b';
persistent CurrentIcell 
global AppleSettings NoApplePlots; 
DoPlot = isempty(NoApplePlots);

dispHelp =0;
if nargin<1,
   dispHelp = 1;
elseif isequal('help', varargin{1}),
   dispHelp = 1;
end

% display settings
if dispHelp,
   disp('==============================================')
   disp('==============================================')
   disp('Persistent settings:')
   disp('  filename:   datafile name');
   disp('    cdelay:   comp. delay (ms) in component-phase display');
   disp('==============================================')
   disp('==============================================')
   if ~isempty(AppleSettings),
      disp('-----current apple settings------')
      disp(AppleSettings);
      disp('---------------------------------')
   end
   return
end

%-----------persistent settings----------------
% persistent FN CDELAY MTDELAY BPH_SHIFT IPLOT XLIMITS MINCONF CPDELAY TITLE1 TITLE2
persistent IPLOT XLIMITS  TITLE1 TITLE2
doReturn=1;
if isequal(varargin{1},'filename'),
   AppleSettings.FN = varargin{2};
elseif isequal(varargin{1},'cdelay'),
   qqq = varargin{2}; 
   if ischar(qqq), qqq=str2num(qqq); end
   AppleSettings.CDELAY = qqq;
elseif isequal(varargin{1},'replot'),
   IPLOT = 0;
else, doReturn=0;
end
if doReturn, return; end;
%varargin

%--------------default values--------------------
if ~isfield(AppleSettings,'FN'),
   error('No filename specified; use APPLE filename FOO');
end
if ~isfield(AppleSettings,'CDELAY'), AppleSettings.CDELAY=0; end;
if isempty(IPLOT),
   IPLOT = 0;
end

%----------------------------------------------
iSeq = varargin{1};
if iscell(iSeq),
   AppleLastMedianPhase = [];
   if ischar(iSeq{1}) & isequal('x', iSeq{1}), iSeq = iSeq(2:end);
   elseif DoPlot, 
      figure;
      if atkiwi, set(gcf, 'posi', [355 223  790 595]); end
   end
   IPLOT = 0;
   Nseq = length(iSeq);
   Y = [];
   if nargin>4, PhaseOffset=varargin{5}; else, PhaseOffset=0; end
   for jj=1:Nseq;
      try, varargin{5} = PhaseOffset(jj);
      catch, varargin{5}=0;
      end
      seqjj = iSeq{jj};
      if isequal('replot', seqjj), IPLOT = 0; continue;
      elseif ischar(seqjj), eval(seqjj, 'warning(lasterr)');
      else, 
         y = apple(seqjj, varargin{2:end});
         Y = [Y y];
      end
   end
   global LastGrapeArg LastAppleArg LastAppleResult
   LastAppleArg = varargin{1};
   LastGrapeArg = LastAppleArg;
   LastAppleResult = Y;
   return;
end


% ======= single spike set from here ==========
if nargin<2, varargin{2} = 1.5; end
apple('cdelay', varargin{2});
%nargin
%varargin{:}
%AppleSettings

%--------------plot arguments-------------
IPLOT = IPLOT+1;
curco = ploco(IPLOT); curma = ploma(IPLOT);
%---------------------------------------------
AS = AppleSettings; 
%disp(DealStructCommandStr(AppleSettings))
eval(DealStructCommandStr(AppleSettings));
%---------------------------------------------

% get data, compute cycle histogram and its spectrum
chs = BNhisto(FN, iSeq, 'BNhisto'); % last arg is cache file name
CurrentIcell = chs.iCell;
% bookkeeping variables
BN = chs.BN; if iscell(BN), BN=BN{1}; end; % assuming different elements are equivalent
SPLear = BN.pp.active; % ear from which to extract the SPL
if isequal(0,SPLear), % both DA channels active
   SPLear = 3-BN.pp.NoiseEar; % the no-noise ear
   if isequal(0,SPLear), SPLear = 1; end % diotic zwuis -> take 1st channel by convention
end
SPL = BN.pp.SPL(SPLear) + BN.PreEmp; SPL=SPL(:); % SPL per component
df = BN.DDfreq; % minimum spacing step of components
Kfreq = BN.Kfreq; % carrier freqs as multiples of df
global TOSScmp; if ~isempty(TOSScmp), Kfreq(TOSScmp)= []; end
Ncar = length(Kfreq);
Kbeat = localBeat(Kfreq,1); % beat freqs as multiples of df
Fcar = 1e-3*df*Kfreq(:).'; % carrier freqs in kHz
Fbeat = 1e-3*df*Kbeat; % freq freqs in kHz

% stimulus
StimSpec = BN.EE0; % complex amplitudes of carriers
if ~isempty(TOSScmp), StimSpec(TOSScmp)= []; end; clear global TOSScmp
StimAmp = a2db(abs(StimSpec)); StimAmp = StimAmp - mean(StimAmp); % relative amplitides of carriers
NormStimSpec = StimSpec./abs(StimSpec).*db2a(StimAmp); % normalized complex amplitudes of carriers
% response
Nspike = chs.Nspike;
Nfreq = chs.Nfreq; % # freq cmpnts in spectrum
RespSpec = conj(chs.CHspec(min(end,Kfreq+1))); % complex amplitudes of carrier cmps in response
VScar = abs(chs.CHspec(min(end,Kfreq+1)))/Nspike; % Vector strength of carrier components
VSref = RayleighCrit(Nspike, RC); % reference vector strength needed for meeting RC above
RScar = RayleighSign(VScar ,Nspike); % Rayleigh significance of carrier components
iclash = find(ismember(Kfreq, Kbeat)); % indices of carriers that coincide with beats
isign = find(RScar<=RC); % indices of carriers that meet RC
inonsign = find(RScar>RC); % indices of carriers that meet RC
% transfer fnc
%dsiz(RespSpec,NormStimSpec,Nspike); 
TRF = RespSpec./NormStimSpec/Nspike; % complex transferspec, doubly normalized


localStoreInDataBase(FN, iSeq, chs); % bookkeeping if requested
global NoApplePlots; 
if ~DoPlot, 
   disp([num2sstr(iSeq) ' --- Apple plot suppressed due to non-empty global "NoApplePlots".'])
   return; 
end;
pause(0.1); % this might improve interruptibility
%=======PLOT======================================
subplot(2,1,1); % ----AMPL----
TRFamp = a2db(abs(TRF)); % vector strength to Raleigh crit, in dB
sigmask = pmask(RScar<=RC);
insigmask = pmask((RScar>RC) & (RScar<=RCcr));
xSplot(Fcar, TRFamp+insigmask, [':' curco]);
xplot(Fcar, TRFamp+insigmask, [curma curco],'markersize', 4);
xplot(Fcar, TRFamp+sigmask, [curco '-']);
xplot(Fcar, TRFamp+sigmask, [curma curco]);
set(gca,'XLimMode','auto'); XL1 = xlim;
ylabel('Amplitude (dB)');
% set(gca,'xticklabel',[])
if nargin>3, if ~isempty(varargin{4}), ylim(varargin{4}); end; end
grid on;
%=
subplot(2,1,2); % ----PHASE----
TRFphase = angle(TRF)/2/pi; % in cycles
insigmask = pmask((RScar>RC) & (RScar<=RCcr));
%dsiz(TRFphase, Fcar, CDELAY)
TRFphase = delayPhase(TRFphase, Fcar, CDELAY, 1); % impose compensating delay, then unwrap
if isempty(AppleLastMedianPhase), AppleLastMedianPhase=-0.5; end
MedPh = median(denan(TRFphase+sigmask));
% AppleLastMedianPhase
jump = round(AppleLastMedianPhase-MedPh);
if ~isempty(jump), 
   TRFphase = TRFphase + jump; % choose phase as close to last phase curve as feasible
   AppleLastMedianPhase = MedPh + jump; % update last median value of phase
end
%AppleLastMedianPhase
if nargin>4, TRFphase = TRFphase + varargin{5}; end
xplot(Fcar, TRFphase+insigmask, [':' curco]);
xplot(Fcar, TRFphase+sigmask, [curma curco '-']);
xplot(Fcar, TRFphase+insigmask, [curma curco],'markersize', 4);
if nargin>2, if ~isempty(varargin{3}), ylim(varargin{3}); end; end
set(gca,'XLimMode','auto'); XL2 = xlim;
xlabel('Frequency (kHz)');
ylabel('Phase (cycle)');
title(['comp delay: ' num2str(CDELAY) ' ms']);
grid on
% equalize x limits
XL = [min(XL1(1), XL2(1)), max(XL1(2), XL2(2))];
subplot(2,1,1); xlim(XL);
subplot(2,1,2); xlim(XL);

Y = collectInStruct(Fcar, SPL, VScar, VSref, RScar, TRF, TRFphase, TRFamp, iclash, isign, CDELAY, iSeq);

% ---------------locals-----------------
function Kbeat = localBeat(Kcar, doRound);
% compute all positive beat freqs from given carrier freq
if nargin<2, doRound=0; end;
% normalize to prevent overflow etc
[mm, ss] = deal(mean(Kcar), std(Kcar));
Kcar = (Kcar(:)-mm)/ss;
Kbeat = log(exp(Kcar)*exp(-Kcar).'); % all differences
Kbeat = (ss*Kbeat);
if doRound, Kbeat=round(Kbeat); end
Kbeat = unique(abs(Kbeat));
Kbeat(find(Kbeat==0))=[];

function localStoreInDataBase(FN, iSeq, chs);
% store input & stimulus parameters in global variable
global AppleStock
if isempty(AppleStock), return; end;
if isnumeric(AppleStock), AppleStock=[]; end; % initialize
iCell = chs.iCell;
QQ = collectInStruct(FN,iCell,iSeq);
BN = chs.BN;
if iscell(BN), BN=BN{1}; end;
spar = BN.pp; % stimulus parameters
QQ.SPL = spar.SPL(max(1,spar.active));
for ii=1:length(AppleStock), % escape if not new
   if isequal(QQ,AppleStock(ii)), 
      return; 
   end
end
AppleStock = [AppleStock QQ]; % store

