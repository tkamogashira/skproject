function [AmPhCo, CHist, PW, advice, Espec, critSpecLevel, BN] = Banana(FN, iSeq, Exp, testFilt);
% banana - analyze BN data
persistent CompDelay AnaOrder MaxTestCompDelay MinConfPlot TitleHandle2
RC = 0.001; % criterium for rayleigh significance

% ---------initialize return variables
PW = {}; advice = []; Espec = []; AmPhCo = {};
% ---------figure positions
if atBigScreen, 
   F1POS = [611   356   448   443];
   F2POS = [11   210   586   682];
elseif inUtrecht, 
   F1POS = [416   175   359   351];
   F2POS = [10   183   397   348];
else, 
   F1POS = [583   304   448   300];
   F2POS = [25   168   527   519];
end
% --------- default inarg values
if isempty(CompDelay), CompDelay = 0; end
if isempty(AnaOrder),  AnaOrder = 0;  end
if isempty(MaxTestCompDelay), MaxTestCompDelay = 4; end
if isempty(MinConfPlot), MinConfPlot = -1; end
% --------- special calls: persistent settings
if isequal(FN,'setdelay'), 
   CompDelay = iSeq;
   return;
elseif isequal(FN,'setorder'),
   AnaOrder = iSeq;
   return;
elseif isequal(FN,'maxdelay'),
   MaxTestCompDelay = iSeq;
   return;
elseif isequal(FN,'minconf'),
   MinConfPlot = iSeq;
   return;
end

if nargin<3, Exp=1; end;
if nargin<4, testFilt=[]; end;

if iscell(iSeq),
   if ishandle(1), delete(1); end;
   if ishandle(2), delete(2); end;
   for ii=1:length(iSeq),
      [AmPhCo{ii} ,CHist, PW{ii}] = Banana(FN,iSeq{ii}, Exp, testFilt);
   end
   iCell = iseq2id(FN, -iSeq{1}(1));
   iCell = strtok(iCell, '-');
   global BN_ID
   BN_ID = [FN '_cell' iCell];
   tttt = ['File ' FN ', cell ' iCell];
   f1; title(tttt);
   get(TitleHandle2,'string');
   tttt2 = [ tttt ' --- ' get(TitleHandle2,'string')];
   set(TitleHandle2,'string', tttt2);
   orange('setdefargs', FN, iSeq);
   return;
end

if (length(iSeq)==1) & isreal(iSeq),
   Nsub = sgsrNsubRec(FN, real(iSeq));
   if Nsub>1,
      qqq = {};
      if ishandle(2), delete(2); end;
      for isub=1:Nsub,
         qqq = {qqq{:}, iSeq+i*isub};
      end
      [AmPhCo, CHist, PW] = Banana(FN,qqq, Exp, testFilt);
      pp = sgsrpar(FN, real(iSeq));
      XL = 1e-3*[0.9*min(pp.MidFreq) 1.1*max(pp.MidFreq)]; 
      return;
   end
end

% single spike collection from here
iCell = iseq2id(FN, -iSeq(1));
iCell = strtok(iCell, '-');

disp(trimspace(num2str(iSeq)));

noPlots = (nargout>4);
% compute Cycle Hist from spike times
[CHist, pp, isub, BN, Ncomp, Espec, misc, icache] = localGetCH(FN, iSeq, RC, Exp, imag(CompDelay), noPlots);
eval(DealStructCommandStr(misc)); % unpack fields of misc

if noPlots, return; end; % no plotting

%---------------------------------------------------

persistent plotColor;
if ~ishandle(2) | isempty(plotColor), plotColor=0; end;
plotColor = plotColor+1;
curco = ploco(plotColor);
curma = ploma(plotColor);
plotArg = [curco '.'];
plotArgCC = [curco 'o'];
dfreq = BN.DDfreq(isub)*1e-3; % freq spacing in kHz
freqs = (0:Nfreq-1)*dfreq; % freq axis 
allDFs = [];
DFtriangle = zeros(Ncomp,Ncomp-1);
DF1 = BN.DF1(isub,:);
alpha = 1+zeros(Ncomp, Ncomp);
allAlphas = [];
for ii=1:Ncomp-1,
   iistr = num2str(ii);
   DF = 1+getfield(BN,['DF' iistr]); % indices of beatcomponents
   DF = DF(isub,:);
   VS = abs(Espec(DF))/Nspike; % vector strength
   for jj=1:Ncomp-ii,
      rrr = RayleighSign(VS(jj) ,Nspike);
      if ismember(DF(jj),BN.Kfreq+1), rrr = 0.5; end% beat freq coincides with carrier - ignore it
      alpha(jj,jj+ii) = rrr;
      alpha(jj+ii,jj) = rrr;
      allAlphas = [allAlphas, rrr];
   end
   DFi{ii} = DF;
   EE = getfield(BN,['EE' iistr]); % spectral Xcorr coeffs of corresponding beat
   EE = EE(isub,:);
   Trf{ii} = Espec(DF)./EE;
   allDFs = [allDFs, DF];
   ccc = conv(DF1,ones(1,ii));
   DFtriangle(ii,1:Ncomp-ii) = ccc(ii:Ncomp-1);
end
% confidence weights
confMatrix = (alpha <= RC);
conf = sum(confMatrix);
[dummy, imaxConf] = max(conf); % index of comp w maximum confidence

% mormalize CH spectrum using Rayleigh criterium
PowerSpec = a2db(abs(Espec))-critSpecLevel; % power spectrum of envelope re crit
MaxNspec = max(allDFs)+10; % max spectral component included in analysis
BGindex = 1:MaxNspec; % indices of background spectrum
BGindex(allDFs) = []; % remove indices of true beats
BGfreqs = freqs(BGindex);
BeatFreqs = freqs(allDFs);
BGspec = PowerSpec(BGindex); % background spectrum
BeatSpec = PowerSpec(allDFs);


% plot
f1; hold on; set(1, 'position',F1POS);
%[583   304   448   300]
plot(freqs,PowerSpec,[curco '.']);
% xplot(BeatFreqs, CompBeatSpec,[curco 'o'],'markersize',8);
xplot(BeatFreqs, BeatSpec,['w.']);
Mstr = '123456789ABCDEFGHIJKLMNOPQRSTUVWXXXXXXXXXXXXXXXXXXX';
for ii=1:length(DFi),
   rBeatFreq = freqs(DFi{ii});
   rBeatSpec = PowerSpec(DFi{ii});
   for jj = 1:length(DFi{ii}),
      marker = [Mstr(ii+jj)];
      rbf = rBeatFreq(jj); 
      text(rbf, rBeatSpec(jj) , marker, ...
         'fontsize', 8, 'color', curco);
   end
end
carIndex = 1+BN.Kfreq;
carFreqs = freqs(carIndex);
xplot(carFreqs, PowerSpec(carIndex),[curco 'o']);
xplot([0 max(freqs)], [0 0], curco); % criterium level 
xlim(dfreq*[0 MaxNspec]);
maxPower = max(PowerSpec);
set(gca,'ylimmode','auto');
xplot(0,maxPower,'marker','none'); % force ylim to consider beat components
YL = ylim; ylim([-20 YL(2)]);
% ylim([-30 30]);
grid on
xlabel('Envelope Frequency (kHz)');

% freq ranges
PhaseFreq = BN.Kfreq(isub,:)*BN.DDfreq(isub)/1e3; % component freqs in kHz
AmpFreq = sqrt(PhaseFreq(1:end-1).*PhaseFreq(2:end)); % in-between values
minFreq = min(PhaseFreq);
maxFreq = max(PhaseFreq);

% Gain analysis
allTRFs = cat(2,Trf{:});
weights = 1./allAlphas';
mmm=local_XcorrMatrix(Ncomp, weights);
allCCs = a2db(abs(allTRFs));
allCCs = allCCs(:).*weights; % column vector
PW = mmm\allCCs;
Gain = PW-max(PW); % set max gain  to zero by convention
AAAA = mmm*PW;

% Phase analysis
% 1st order: only next-door neighbours
dph = [0 -angle(Trf{1})]; % phase differences in radians
compPhase = 2*pi*(real(CompDelay)*PhaseFreq);
PH = unwrap((cumsum(dph) + compPhase)) /2/pi; % rad->cyc
PH = PH-PH(ceil(end/2));
% all-order, weighted analysis
mPh = local_phaseDiffMatrix(Ncomp, weights, imaxConf); % weighted version
mPhUW = local_phaseDiffMatrix(Ncomp, ones(1,size(mPh,1)), imaxConf); % unweighted version
mPhUW(1,:) = []; % elimimate non-difference term
% find compensatory delay that yields minimum weighted SSQ error

bestCompDelay = localGetFromMisc(icache,'bestCompDelay', NaN);
OldMaxTestCompDelay = localGetFromMisc(icache,'MaxTestCompDelay', NaN);
if ~isequal(MaxTestCompDelay, OldMaxTestCompDelay), bestCompDelay=NaN; end
if isnan(bestCompDelay), % first time: do the computation
   if length(MaxTestCompDelay)==1, mmmm = 0; else, mmmm=MaxTestCompDelay(1); end;
   testCompDelay = linspace(mmmm,MaxTestCompDelay(end),161);
   minError = inf;
   for tcd=testCompDelay,
      compPhase = 2*pi*(real(tcd)*PhaseFreq);
      BeatCompPhase = (mPhUW*compPhase')';
      BeatPhases = angle(exp(i*(-angle(allTRFs)+BeatCompPhase)));
      W_BeatPhases = [0; weights.*BeatPhases(:)];
      SSQ = sum(W_BeatPhases.^2);
      if SSQ<minError,
         bestCompDelay = tcd;
         minError = SSQ;
      end
   end
else, '...'
end
bestCompDelay

localAddToMisc(icache, 'bestCompDelay', bestCompDelay); % avoid doing this all over
localAddToMisc(icache, 'MaxTestCompDelay', MaxTestCompDelay); % avoid doing this all over

compPhase = 2*pi*(real(bestCompDelay)*PhaseFreq);
BeatCompPhase = (mPhUW*compPhase')';
BeatPhases = angle(exp(i*(-angle(allTRFs)+BeatCompPhase)));
% f3; plot(BeatPhases/2/pi); pause; delete(3);
W_BeatPhases = [0; weights.*BeatPhases(:)];
ComponentPhases = mPh\W_BeatPhases;
delayMisMatch = real(CompDelay)-bestCompDelay;
phaseMismatch = 2*pi*delayMisMatch*PhaseFreq(:);
ComponentPhases = (ComponentPhases + phaseMismatch)/2/pi;
ComponentPhases = ComponentPhases - ComponentPhases(ceil(end/2));

%-----------PLOTS----------------------
% determine freq range
plotFreq = 0.5*( minFreq+maxFreq + [-1 1]*1.5*(maxFreq-minFreq));
plotFreq = 0.5*[floor(2*plotFreq(1)) ceil(2*plotFreq(2)) ];
if plotFreq(1)==plotFreq(2),
   plotFreq(1) = plotFreq(1) - 0.5;
   plotFreq(2) = plotFreq(2) + 0.5;
end
if ishandle(2), f2; oldXL = xlim; else, oldXL = [inf, -inf]; end;
plotFreq(1) = min(plotFreq(1),oldXL(1)); plotFreq(1) = max(0,plotFreq(1));
plotFreq(2) = max(plotFreq(2),oldXL(2));

f2; set(2,'position', F2POS);

% conf
plotind = find(conf>=MinConfPlot); % only plot self-confident data points

subplot(3,1,1); % ampl
xplot(PhaseFreq(plotind),Gain(plotind), [curco curma '-']);
xlim(plotFreq);
ylabel('Gain (dB)');
TitleHandle2 = title(['Comp delay = ' num2str(CompDelay) ' ms; Min conf = ' num2str(MinConfPlot)]);
grid on

subplot(3,1,2); % phase
% xplot(PhaseFreq, PH, ['x' curco]);
xplot(PhaseFreq(plotind), ComponentPhases(plotind), ['-' curco]);
ylabel('Phase (cycles)');
% title(strvcat(' ',' ',['delay = ' CompDelay  ' ms']));
xlim(plotFreq);
grid on

subplot(3,1,3); % confidence weights
set(gca,'ylimmode','auto');
xplot(freqs(BN.Kfreq(isub,:)),conf+0.2*rand(size(conf)), ['-' curma curco]); % jitter to avoid masking
xlim(plotFreq);
ylabel('Confidence in estimate)');
xlabel('Freq (kHz)');
YL = ylim;
grid on;
ylim([0 YL(2)]);

% return plotted material
AmPhCo.FN = FN;
AmPhCo.iSeq = iSeq;
AmPhCo.Freq = PhaseFreq;
AmPhCo.Gain = Gain;
AmPhCo.Phase = ComponentPhases;
AmPhCo.Conf = conf;
AmPhCo.Reliable = plotind;
AmPhCo.compdelay = CompDelay;
AmPhCo.iCell = iCell;

% advise New Style ...
advice = round(PW(:).'); % row vector
advice = advice - min(advice);
global LastAdvice
LastAdvice = advice;

%--------------------
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

function m=local_phaseDiffMatrix(N, weights, zeroComp);
m = [];
for dist=1:N-1,
   for offset=1:N-dist,
      newRow = zeros(1,N);
      newRow(offset+[0, dist]) = [-1 1];
      m = [m; newRow];
   end
end
% apply weights
for irow=1:size(m,1), % all rows
   m(irow,:) = m(irow,:)*weights(irow);
end
% add trivial first row to fix one component
triv = [zeros(1,zeroComp-1) 1 zeros(1,N-zeroComp)];
m = [triv; m];

function w = local_SpecWeights(Kfreq, DFindices, CompBeatSpec, BGstd);
EEE = 2;
w = zeros(size(Kfreq));
for ii=1:length(Kfreq),
   DF = abs(Kfreq-Kfreq(ii)); % beat freqs involving ii-th comp in units of fundamental
   DF = DF(find(DF>0)); % remove zero "auto-beat" term
   for df=DF, % visit all beat freqs involving ii-th component
      specIndex = find(df==DFindices-1); % index in beatspectrum of current beat freq
      specIndex = specIndex(1); % avoid crashes do do poorly spaces Env spec
      trtr = CompBeatSpec(specIndex)-BGstd;
      trtr = max(trtr,0);
      w(ii) = w(ii) + trtr.^EEE;
   end
   w(ii) = w(ii)/length(DF).^EEE;
end
w = w.^(1/EEE);




%-----------------more locals----------------
function icache = localStoreCHinfo(param, values);
Ncache = 10;
global BNCache BNicache
if isempty(BNicache),
   BNCache = cell(1,Ncache);
   BNicache = 1;
else,
   BNicache = rem(BNicache,Ncache) + 1;
end
icache = BNicache;
BNCache{BNicache} = CollectInStruct(param, values);

function [values, icache] = localRetrieveCHinfo(param);
values = []; icache = [];
try
global BNCache BNicache
   for ii=1:length(BNCache),
      if isequal(param, BNCache{ii}.param),
         values = BNCache{ii}.values;
         icache = ii;
         break;
      end
   end
catch, % disp(lasterr);
end

function localAddToMisc(icache,fn,fv);
% adds field to misc field of cached data
global BNCache
eval(['BNCache{icache}.misc.' fn ' = fv;' ]);
function fv = localGetFromMisc(icache,fn, default);
% gets field from misc field of cached data
global BNCache
fv = default;
try
   fv = getfield(BNCache{icache}.misc, fn);
end


function [CHist, pp, isub, BN, Ncomp, Espec, misc, icache] = localGetCH(FN, iSeq, RC, Exp, noiseLevel, noPlots);

% try if in cache
[values, icache] = localRetrieveCHinfo(CollectInstruct(FN, iSeq, RC, Exp, noiseLevel));
if ~isempty(values),
   eval(DealStructCommandStr(values));
   return;
end

% get spike times
[spt, pp, isub] = SGSRgetSpikeTimes(FN, iSeq, 'BN');
BN = prepareBNstim(pp);
BN = rmfield(BN,{ 'SpecL', 'SpecR', 'CWaveL', 'CWaveR'});
isub = 1;
try,
   ni = BN.pp.NoiseEar
   if (ni==1) isub = 2; end
end
Tcyc = 1e3/BN.DDfreq(1) % exact stimulus period in ms
Ncyc = BN.Ncyc(isub);
Ncomp = length(BN.Kfreq);
global DEBUGdelay; if ~isempty(DEBUGdelay), spt = spt + DEBUGdelay; end;
spt = spt-Tcyc; % spikes before end of risetime will be negative
spt = spt(find(spt>0)); % ignore rise time
spt = spt(find(spt<=Ncyc*Tcyc)); % ignore fall time and beyond
spt = rem(spt,Tcyc); % wrap around Tcyc
% histo
DT = 1e3/BN.Fsam(1); % sample period in ms for histogram
Edges = (0:BN.NsamCyc(isub))*DT;
CHist = histc(spt,Edges);
if isempty(CHist), % histc is empty - shouldn't be
   CHist = Edges*0;
end
CHist(end) = []; % remove final garbage bin (see help histc)

if noiseLevel~=0,
   CHist = CHist + noiseLevel*rand(size(CHist));
end
if Exp<0, % test run, take envelope of stimulus
   if ~isempty(testFilt),
      %xx = [BN.CWaveL, BN.CWaveL, BN.CWaveL];
      %xx = conv(xx, testFilt);
      xx = fft(BN.CWaveL(isub,:));
      ind = BN.Kfreq(isub,testFilt(1,:))+1;
      xx(ind) = testFilt(2,:).*xx(ind);
      xx = ifft(xx);
      CHist = abs(xx); 
   else,
      CHist = abs(BN.CWaveL(isub,:)); 
   end
   Exp = abs(Exp);
end
% fourier analysis of envelope
Espec = length(CHist)*ifft(CHist.^Exp);
Nspike = Espec(1);
Espec(1) = abs(Espec(2));
Nfreq = round(length(Espec)/2);
Espec = Espec(1:Nfreq); % neg freqs not interesting
critSpecLevel = a2db(RayleighCrit(Nspike, RC)*Nspike);
misc = CollectInStruct(critSpecLevel, Nspike, Nfreq);
% store info to save time on next call
icache = localStoreCHinfo(collectInstruct(FN, iSeq, RC, Exp, noiseLevel), ...
   collectInstruct(CHist, pp, isub, BN, Ncomp, Espec, misc));
if noPlots, return; end; % banana passes args and returns

