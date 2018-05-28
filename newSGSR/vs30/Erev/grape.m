function [X, background, grC] = grape(varargin);
% GRAPE - Zwuis data processing using dataset objects
RC = 0.001; % criterium for Rayleigh significance
curco = 'b';
persistent CurrentIcell 
global GrapeSettings 

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
   disp('        mc:   min. confidence [2]');
   disp('    cdelay:   comp. delay (ms) in component-phase display');
   disp('   mtdelay:   [min max] comp. delay (ms) of beat components');
   disp('==============================================')
   disp('==============================================')
   if ~isempty(GrapeSettings),
      disp('-----current grape settings------')
      disp(GrapeSettings);
      disp('---------------------------------')
   end
   return
end

%-----------persistent settings----------------
% persistent FN CDELAY MTDELAY BPH_SHIFT IPLOT XLIMITS MINCONF CPDELAY TITLE1 TITLE2
persistent IPLOT XLIMITS  TITLE1 TITLE2
doReturn=1;
if isequal(varargin{1},'filename'),
   GrapeSettings.FN = varargin{2};
   apple('filename', varargin{2});
elseif isequal(varargin{1},'cdelay'),
   GrapeSettings.CDELAY = varargin{2};
   orange('setdelay', GrapeSettings.CDELAY);
elseif isequal(varargin{1},'mtdelay'),
   GrapeSettings.MTDELAY = varargin{2};
elseif isequal(varargin{1},'bph_shift'),
   GrapeSettings.BPH_SHIFT = varargin{2};
elseif isequal(varargin{1},'cpdelay'),
   GrapeSettings.CPDELAY = varargin{2};
elseif isequal(varargin{1},'mc'),
   GrapeSettings.MINCONF = varargin{2};
else, doReturn=0;
end
if doReturn, return; end;


%--------------default values--------------------
if ~isfield(GrapeSettings,'FN'),
   error('No filename specified; use GRAPE filename FOO');
end
if ~isfield(GrapeSettings,'CDELAY'), GrapeSettings.CDELAY=1.4; end;
if ~isfield(GrapeSettings,'BPH_SHIFT'), GrapeSettings.BPH_SHIFT=0; end;
if ~isfield(GrapeSettings,'MINCONF'),
   GrapeSettings.MINCONF = 2;
end
if ~isfield(GrapeSettings,'CPDELAY'),
   cpdelay = NaN;
else,
   cpdelay = GrapeSettings.CPDELAY;
end
if ~isfield(GrapeSettings,'MTDELAY'), 
   GrapeSettings.MTDELAY=[1 4]; 
elseif length(GrapeSettings.MTDELAY)==1,
   GrapeSettings.MTDELAY = [1 MTDELAY];
end;
if isempty(IPLOT),
   IPLOT = 0;
end

%----------------------------------------------

iSeq = varargin{1};
if iscell(iSeq),
   try, delete(1);  end; try, delete(2);  end;
   more off;
   Nseq = length(iSeq);
   [X, background, grC] = deal([],[],'');
   for jj=1:Nseq;
      seqjj = iSeq{jj};
      if ischar(seqjj), eval(seqjj, 'warning(lasterr)');
      else, 
         [xx, yy, zz] = grape(seqjj);
         X = [X xx];
         background = [background yy];
         grC = strvcat(grC, '  '.', zz.');
      end
   end
   grC = grC.'; disp(grC);
   global LastGrapeArg LastGrapeResult
   LastGrapeArg = varargin{1};
   LastGrapeResult = X;
   if nargin>1, comment = varargin{2}; else, comment = '??'; end;
   % storage of results
   localAdd2DataBase(X, CurrentIcell, comment);
   return;
end
tic;

%--------------plot arguments-------------
IPLOT = local_WindowDressing(iscell(iSeq), IPLOT);
curco = ploco(IPLOT);
curma = ploma(IPLOT);
if IPLOT==1, 
   XLIMITS = []; 
   TITLE1 = 'Cdelay: ';
   TITLE2 = [GrapeSettings.FN ' '];
end
%---------------------------------------------
GS = GrapeSettings; % not Guido..
eval(DealStructCommandStr(GrapeSettings));
%---------------------------------------------

% get data, compute cycle histogram and its spectrum
global DEBUGgrENV
if ~isempty(DEBUGgrENV),
   chs = BNhisto(FN, iSeq, DEBUGgrENV); % last arg is ENVL or ENVR
else,
   chs = BNhisto(FN, iSeq, 'BNhisto'); % last arg is cache file name
end
%disp(['---------------histo computed/retrieved ' num2str(toc)]); drawnow;
CurrentIcell = chs.iCell;
% bookkeeping variables
BN = chs.BN; if iscell(BN), BN=BN{1}; end; % assuming different elements are equivalent
%public(BN)
SPLear = BN.pp.active; % ear from which to extract the SPL
if isequal(0,SPLear), % both DA channels active
   SPLear = 3-BN.pp.NoiseEar; % the no-noise ear
   if isequal(3,SPLear), SPLear = 1; end % diotic zwuis -> take 1st channel by convention
   if isequal(0,SPLear), SPLear = 1; end % diotic zwuis -> take 1st channel by convention
end
SPL = BN.pp.SPL(SPLear) + BN.PreEmp; SPL=SPL(:); % SPL per component
df = BN.DDfreq; % minimum spacing step of components
Kfreq = BN.Kfreq; % carrier freqs as multiples of df
Ncar = length(Kfreq);
CarSpec = BN.EE0; % complex amplitudes of carriers
Nspike = chs.Nspike;
Nfreq = chs.Nfreq; % # freq cmpnts in spectrum
% beat freqs, transfer coefficients, etc
[Kbeat, BeatSpec] = local_DFtrian(Kfreq, CarSpec); % i/j beat component: ...
%                         ... DFT(i,j) = Kfreq(j)-Kfreq(i), j>i; ...
%                         ... BeatSpec(i,j) = conj(Car(j)).*Car(i)
VS = abs(chs.CHspec(min(end,Kbeat+1)))/Nspike; % Vector strength of i/j beat cmp
% f3; contour(flipLR(a2db(VS))); pause; delete(3);
VS(find(Kbeat==0)) = 0; % meaningless, non-upper triangle components
RS = RayleighSign(VS ,Nspike); % Rayleigh significance of i/j beat cmp
clash = find(ismember(Kbeat(:), Kfreq)); % indices of beats that coincide with carriers
RS(clash) = 0.5; % clashing beat component are useless
global TOSScmp
IDtoss=TOSScmp;
if isfield(BN,'toss') & (BN.pp.BNversion<8), % disable tossed components
   Toss = Kfreq; Toss(BN.toss)=nan; % improper components are nans
   Toss = local_DFtrian(Toss, Toss*0+1);
   iToss = find(isnan(Toss)); % indices of beat components to be tossed
   RS(iToss) = 0.5; % effective disabling of tossed beats
end
if ~isempty(TOSScmp),
   Toss = Kfreq; Toss(TOSScmp)=nan; % improper components are nans
   Toss = local_DFtrian(Toss, Toss*0+1);
   iToss = find(isnan(Toss)); % indices of beat components to be tossed
   RS(iToss) = 0.5; % effective disabling of tossed beats
   TOSScmp = []; % use only once or else will confuse subsequent analyses
end
RSV = local_BeatM2V(RS); % Raleygh signficances of indiv beats as vector
PConf = RS<=RC; Conf = PConf+PConf.'; Conf = sum(Conf,2); % col vector
PConf = PConf|PConf.'; grC = repmat(' ',size(PConf)); grC(find(PConf))='#';
PConf = RS==0.05; PConf=PConf|PConf.'; grC(find(PConf))='O'; grC = strvcat(['----' num2str(IPLOT) '-----'],grC); %disp(grC)
Trf = chs.CHspec(min(end,Kbeat+1))./BeatSpec; % complex transfer coefficients of beats
TrfV = local_BeatM2V(Trf); % as a vector
Mweights = 1./RS; % weight factors of beat cmpts as matrix
weights = local_BeatM2V(Mweights); % idem as vector
Fcar = 1e-3*df*Kfreq(:); % carrier freqs in kHz
XLIMITS = local_xlim(XLIMITS, Fcar);
KbeatV = local_BeatM2V(Kbeat); % beat-freq/df as vector
Fbeat = 1e-3*df*KbeatV; % freq freqs in kHz
Tilt = BN.pp.Tilt;

% check = local_BeatV2M(KbeatV)-Kbeat
%Kbeat
%FB = Fbeat';
%GainMatrix = local_XcorrMatrix(Ncar);

%------PHASE-----
[dum, imaxConf] = max(Conf);
%compPhase = 2*pi*(real(CDELAY)*PhaseFreq);
% Ncar, weights, imaxConf
mPh = local_phaseDiffMatrix(Ncar, weights, imaxConf); % weighted version
mPhUW = local_phaseDiffMatrix(Ncar); % unweighted version
% determine best delay
BC_ID = CollectInStruct(FN, iSeq, MTDELAY, BPH_SHIFT, IDtoss); % unique identifier of bestcompdelay calculation
%disp(['---------------ready to retrieve BCOMP ' num2str(toc)]); drawnow;
BCOMP = FromCacheFile('BestCompDelay', BC_ID);
if ~isempty(BCOMP), 
   eval(DealStructCommandStr(BCOMP)); % unpack
   %disp(['---------------BCOMP retrieved ' num2str(toc)]); drawnow;
else,
   % new computation
   testCompDelay = linspace(MTDELAY(1),MTDELAY(2),161);
   minError = inf;
   bphShift = 0;
   for tcd=testCompDelay,
      %carPhaseShift = 2*pi*tcd*Fcar; % phase shift off carrier components due to compensating delay
      %beatPhaseShift = (mPhUW*carPhaseShift'); % idem beat components
      beatPhaseShift = 2*pi*tcd*Fbeat;
      BeatPhases = angle(exp(2i*(-angle(TrfV) + beatPhaseShift))); % factor two to allow for Suppressive beats
      W_BeatPhases = [weights.*BeatPhases(:)];
      if BPH_SHIFT, 
         SSQ = var(W_BeatPhases);
         bphShift = sum(weights.*BeatPhases)/sum(weights);
      else, SSQ = sum(W_BeatPhases.^2);
      end
      if SSQ<minError,
         bestCompDelay = tcd;
         bestBphShift = bphShift;
         minError = SSQ;
      end
   end
   BCOMP = collectInStruct(bestCompDelay, bestBphShift);
   ToCacheFile('BestCompDelay', 1e2, BC_ID, BCOMP); % store for next time
   %disp(['---------------BCOMP computed/stored ' num2str(toc)]); drawnow;
end
%disp(['best comp delay = ' num2str(bestCompDelay) 'ms     beat phase shift = ' num2str(bestBphShift/2/pi) ' cycle']);

%disp(['---------------PHASE estimated ' num2str(toc)]); drawnow;


if isnan(cpdelay) | cpdelay>0,
   BestcarPhaseShift = 2*pi*(bestCompDelay*Fcar);
   BestBeatPhaseShift =  2*pi*(bestCompDelay*Fbeat) - bestBphShift;
else,
   % 'forcing cpdelay'
   cpdelay = abs(cpdelay);
   BestcarPhaseShift = 2*pi*(cpdelay*Fcar);
   BestBeatPhaseShift =  2*pi*(cpdelay*Fbeat) - bestBphShift;
end

BeatPhases = angle(exp(i*(-angle(TrfV)+BestBeatPhaseShift)));

if isequal(Ncar, length(Tilt)),
   absent = find(Tilt==88); % components in gap
   carPresence = zeros(1,Ncar);
   carPresence(absent) = nan;
   beatPresence = carPresence'*carPresence; 
   TrueBeats = ~isnan(beatPresence); % zeros indicate a beat between gap components
else, 
   absent = []; % no gap
   TrueBeats = 1; % all beats are valid candidates
end
critPhase = pi/2; global GLCritPhase; 
if ~isempty(GLCritPhase), critPhase = GLCritPhase; end
exciting = local_BeatV2M(abs(BeatPhases)<=critPhase) & (RS<=RC);
exciting = exciting+exciting.';
Mweights = 0.001*Mweights + 0.999*Mweights.*TrueBeats;
exWeights = (local_BeatM2V(Mweights.*(0.99*exciting+0.01)));
sumex = sum(exciting,2);
%
suppressing =  local_BeatV2M(abs(BeatPhases)>critPhase) & (RS<=RC);
suppressing = suppressing+suppressing.';
sumsu = sum(suppressing,2);
suWeights = local_BeatM2V(Mweights.*(suppressing+0.01));

ex_mPh = local_phaseDiffMatrix(Ncar, exWeights, imaxConf); % exweighted version
su_mPh = local_phaseDiffMatrix(Ncar, suWeights, imaxConf); % suweighted version
%local_BeatV2M(
%local_BeatV2M
% qqq=BeatPhases(:)'
% f3; plot(BeatPhases/2/pi); pause; delete(3);
W_BeatPhases = [0; weights.*BeatPhases(:)];
exW_BeatPhases = [0; exWeights.*BeatPhases(:)];
SuBeatPhases = angle(exp(i*(BeatPhases-pi)));   % compensate negativity inherent in suppression
suW_BeatPhases = [0; suWeights.*SuBeatPhases(:)];
ComponentPhases = mPh\W_BeatPhases;
exComponentPhases = ex_mPh\exW_BeatPhases; 
xPgof = rms(ex_mPh*exComponentPhases-exW_BeatPhases)/mean(exWeights);
suComponentPhases = su_mPh\suW_BeatPhases;
sPgof = rms(su_mPh*suComponentPhases-suW_BeatPhases)/mean(suWeights);
delayMisMatch = real(CDELAY)-bestCompDelay;
phaseMismatch = 2*pi*delayMisMatch*Fcar;
ComponentPhases = (unwrap(ComponentPhases) + phaseMismatch)/2/pi;
exComponentPhases = (unwrap(exComponentPhases) + phaseMismatch)/2/pi;
suComponentPhases = (unwrap(suComponentPhases) + phaseMismatch)/2/pi;

%-------GAIN----
WGainV = weights.*a2db(abs(TrfV)); % weighted gain coefficients
GainMatrix = local_XcorrMatrix(Ncar, weights);
PW = GainMatrix\WGainV;
Gain = PW-max(PW); % set max gain  to zero by convention
%
exWGainV = exWeights.*a2db(abs(TrfV)); % weighted gain coefficients
GainMatrix = local_XcorrMatrix(Ncar, exWeights);
PW = GainMatrix\exWGainV;
xGgof = rms(GainMatrix*PW-exWGainV)/mean(exWeights);
exGain = PW-max(PW); % set max gain  to zero by convention
%
suWGainV = suWeights.*a2db(abs(TrfV)); % weighted gain coefficients
GainMatrix = local_XcorrMatrix(Ncar, suWeights);
PW = GainMatrix\suWGainV;
sGgof = rms(GainMatrix*PW-suWGainV)/mean(suWeights);
suGain = PW-max(PW); % set max gain  to zero by convention
%checkTRF = (GainMatrix*PW)./weights;
%plot(a2db(abs(TrfV)),'x'); hold on; plot(checkTRF,'o');
%MW = find(weights==max(weights));
%plot(a2db(abs(TrfV(MW))),'r*'); plot(checkTRF(MW),'ro');

%disp(['---------------GAIN estimated ' num2str(toc)]); drawnow;
% FN CDELAY MTDELAY BPH_SHIFT IPLOT XLIMITS MINCONF

%-------PLOT----------------
%dsiz(Conf)
%dsiz(Fcar)
%dsiz(Gain)
%dsiz(ComponentPhases)
exBAD = sumex<MINCONF(1); exBAD(absent) = 1; exOK = ~exBAD;
suBAD = sumsu<MINCONF(end); suBAD(absent) = 1; suOK = ~suBAD;
pconf = zeros(size(Conf));
pconf(find(Conf<MINCONF(1)))=NaN; % plot masker for insignificant points
exconf = zeros(size(sumex)); exconf(find(exBAD))=nan;
suconf = zeros(size(sumsu)); suconf(find(suBAD))=nan;

f2; subplot(3,1,1); xlim(XLIMITS);  grid on;
% xplot(Fcar, pconf+Gain, [curco curma ':']);
xplot(Fcar, exconf+exGain, [curco curma '-'],'linewidth',1.5);
xplot(Fcar, suconf+suGain, [curco curma '-']);
% set(gca,'xtick',[]);
ylabel('Gain (dB)');
TITLE2 = [TITLE2 '[' trimspace(num2str(iSeq)) ']'];
title(TITLE2);

f2; subplot(3,1,2); xlim(XLIMITS); grid on;
ComponentPhases = ComponentPhases - mean(ComponentPhases);
if ~isempty(find(exOK)), exComponentPhases = exComponentPhases - mean(exComponentPhases(find(exOK))); end;
if ~isempty(find(suOK)), suComponentPhases = suComponentPhases - mean(suComponentPhases(find(suOK))); end;
% xplot(Fcar,pconf+ComponentPhases, [curco curma '-']);
xplot(Fcar,exconf+exComponentPhases, [curco curma '-'], 'linewidth',1.5);
xplot(Fcar,suconf+suComponentPhases, [curco curma '-']);
ylabel('Phase (cycle)')
th = title(['del: ' num2str(CDELAY) ' ms'],'verticalalign','top');

f2; subplot(3,1,3); xlim(XLIMITS); grid on;
%xplot(Fcar,Conf+0.2*rand(size(Conf)), [curco curma '-']);
xplot(Fcar,sumex+0.2*rand(size(sumex)), [curco curma '-'],'linewidth',1.5);
xplot(Fcar,sumsu+0.2*rand(size(sumsu)), [curco curma '-']);
ylabel('Cum. Confidence');
xlabel('Frequency (kHz)');
ylim([0 length(Fcar)]);

%disp(['---------------F2 plotted ' num2str(toc)]); drawnow;

Nfig = length(findobj('type','figure')); if Nfig>12, aa; end
% ---- plot CH power spectrum
f1;
subplot(2,1,1);
hold on;
critSpecLevel = a2db(RayleighCrit(Nspike, RC)*Nspike);
freqs = df*(0:Nfreq-1)/1e3; % in kHz
maxPlotFreq = freqs(min(end,ceil(1.5*max(max(Kbeat)))));
PowerSpec = a2db(abs(chs.CHspec))-critSpecLevel;
ibackground = find(~ismember(1:Nfreq,[1;1+Kbeat(:)]));
ibeat = find(ismember(1:Nfreq,1+Kbeat));
plot(freqs(ibackground), PowerSpec(ibackground), ['.' curco]);
hold on;
carIndex = Kfreq+1; carIndex(find(carIndex>Nfreq)) = [];
plot(freqs(carIndex), PowerSpec(carIndex), ['o' curco]); % carrier components
plot(freqs([1 end]),[0 0]);
Tstr = '123456789ABCDEFabcdefghijklmnopqrstuvwxyzXXXXXXXXXXXXX';
for jj=2:Ncar
   for ii=1:jj-1,
      ifreq = 1+Kbeat(ii,jj);
      text(freqs(min(end,ifreq)), 1+PowerSpec(min(end,ifreq)), Tstr(jj),'color',curco, 'fontsize', 8);
   end
end
xlim([0,maxPlotFreq]);
set(gca,'xticklabel', []);
ylim([-10 20]);
grid on;
background = struct('freq', freqs(ibackground), 'power', PowerSpec(ibackground));
%------plot phase Trf fbeat components
f1;
subplot(2,1,2);
hold on;
% [bbf iii] = sort(Fbeat);
if isnan(cpdelay),
   cpdelay = bestCompDelay;
end
DBbeatPhaseShift = 2*pi*cpdelay*Fbeat-bestBphShift;
bbp = angle(exp(i*(-angle(TrfV)+DBbeatPhaseShift)))/2/pi;
bbp(find(RSV>RC)) = NaN; % do not plot insignificant beats
RrMm = repmat(1:Ncar,[Ncar 1]);
RightComp = local_BeatM2V(RrMm); % this vector indexes the uppermost beat comp
% xplot(bbf, bbp(iii), [curco curma]);
for ii=1:length(bbp),
   bpi = bbp(ii);
   if ~isnan(bpi),
      text(Fbeat(ii), bpi, Tstr(RightComp(ii)),'color', curco, 'fontsize', 8);
   end
end
grid on
xlim([0,maxPlotFreq]);
ylim(0.5*[-1 1]);
ylabel('Beat phase Trf (Cycle)');
xlabel('Frequency (Hz)');
TITLE1 = [TITLE1 num2str(0.01*round(100*cpdelay)) '/ '];
title([TITLE1 ' ms']);
drawnow

%disp(['---------------F1 plotted ' num2str(toc)]); drawnow;
%disp(blanks(3)');

% return params
BeatGain = PowerSpec(min(end,1+KbeatV)); BeatGain = BeatGain(:);
X = CollectInstruct(FN, iSeq, Fcar, SPL, exGain, suGain, ...
   exComponentPhases, suComponentPhases, ...
   sumex, sumsu, ...
   Conf, bestCompDelay, bestBphShift, ...
   BeatGain, BeatPhases,bbp, Fbeat, RSV, ...
   CDELAY,MTDELAY, BPH_SHIFT, MINCONF);


% ---------------locals-----------------
function [DFT, BSP] = local_DFtrian(Kfreq, Car);
% beat matrix: (i,j) comp corresponds to car(j)/car(i) interaction
N = length(Kfreq);
DFT = zeros(N,N); BSP = 1e-80+zeros(N,N);
for ii=1:N,
   for jj=ii+1:N,
      DFT(ii, jj) = Kfreq(jj)-Kfreq(ii);
      BSP(ii, jj) = conj(Car(jj)).*Car(ii);
   end
end
%-----
function y=local_BeatM2V(x);
% converts beat matrix to col vector
if ~isequal(0,diff(size(x))),
   error('Matrix must be square');
end
N = size(x,2);
y = [];
for idiff=1:N-1,
   y = [y; diag(x(1:N-idiff, 1+idiff:N))];
end
%-----
function x=local_BeatV2M(y);
% inverse of local_BeatM2V
N = sqrt(2*length(y)+0.25)+0.5;
N = round(N);
x = zeros(N,N);
offset = 0;
for idiff=1:N-1,
   for ii=1:N-idiff;
      x(ii,ii+idiff) = y(offset+ii);
   end
   offset = offset+N-idiff;
end
%-----
function m=local_XcorrMatrix(N, weights);
m = [];
for dist=1:N-1,
   for offset=1:N-dist,
      newRow = zeros(1,N);
      newRow(offset+[0, dist]) = 1;
      m = [m; newRow];
   end
end
if nargin>1, % apply weights
   for irow=1:size(m,1), % all rows
      m(irow,:) = m(irow,:)*weights(irow);
   end
end
%---
function m=local_phaseDiffMatrix(N, weights, zeroComp);
m = [];
for dist=1:N-1,
   for offset=1:N-dist,
      newRow = zeros(1,N);
      newRow(offset+[0, dist]) = [-1 1];
      m = [m; newRow];
   end
end
if nargin<2, return; end;
% apply weights
for irow=1:size(m,1), % all rows
   m(irow,:) = m(irow,:)*weights(irow);
end
if nargin<3, return; end;
% add trivial first row to fix one component
triv = [zeros(1,zeroComp-1) 1 zeros(1,N-zeroComp)];
m = [triv; m];
% --------------
% ----plotting functions---------
function iplot=local_WindowDressing(anew, iplot);
if isempty(iplot) | all(~ishandle([1 2])), iplot=0; end;
if anew, % re-init all graphics
   if ishandle(1), delete(1); end;
   if ishandle(2), delete(2); end;
   iplot=0;
end
% only re-init when non-existent
figure(1);
subplot(2,1,1);
figure(2); 
subplot(3,1,1);
iplot = iplot+1;
if atBigScreen, 
   F1POS = [799   217   448   679];
   F2POS = [204   214   586   682];
elseif inUtrecht, 
   F1POS = [416   175   359   351];
   % F2POS = [10   183   397   348];
   F2POS = [113   183   294   348];
elseif atSnail,
   F1POS = [583   169   448   517];
   F2POS = [25   168   527   519];
else, 
   F1POS = [583   169   448   517];
   F2POS = [114   232   438   455]; 
end
set(1,'position',F1POS);
set(2,'position',F2POS);

function xl = local_xlim(xl, Fcar);
% determine xlimits (fcar in kHz)
if isempty(xl), 
   xl = [inf, -inf]; 
end;
minFreq = min(Fcar);
maxFreq = max(Fcar);
plotFreq = 0.5*( minFreq+maxFreq + [-1 1]*1.5*(maxFreq-minFreq));
plotFreq = 0.5*[floor(2*plotFreq(1)) ceil(2*plotFreq(2)) ];
if plotFreq(1)==plotFreq(2),
   plotFreq(1) = plotFreq(1) - 0.5;
   plotFreq(2) = plotFreq(2) + 0.5;
end
xl(1) = max(0, min(plotFreq(1), xl(1)));
xl(2) = max(plotFreq(2), xl(2));


function localAdd2DataBase(X, ic, comment);
global GrapeFruit
if isempty(GrapeFruit),
   GrapeFruit = struct('hello', '---');
end
fname = ['G' num2str(ic)];
cname = ['C' num2str(ic)];
if isfield(GrapeFruit, fname), 
   vv = getfield(GrapeFruit, fname);
   cc = getfield(GrapeFruit, cname);
   GrapeFruit = setfield(GrapeFruit, fname, {vv{:} X});
   GrapeFruit = setfield(GrapeFruit, cname, {cc{:} comment});
else,
   GrapeFruit = setfield(GrapeFruit, fname, {X});
   GrapeFruit = setfield(GrapeFruit, cname, {comment});
end












