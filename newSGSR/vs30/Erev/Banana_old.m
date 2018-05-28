function [CHist, PW, advice, Espec] = Banana(FN, iSeq, Exp, testFilt);
% banana - analyze BN data
persistent CompDelay AnaOrder
PW = {}; advice = []; Espec = [];
if atBigScreen, 
   F1POS = [611   356   448   443];
   F2POS = [11   210   586   682];
else, 
   F1POS = [583   304   448   300];
   F2POS = [25   168   527   519];
end
   
iSeq

if isempty(CompDelay),
   CompDelay = 0;
end
if isempty(AnaOrder),
   AnaOrder = 0;
end
if isequal(FN,'setdelay'),
   CompDelay = iSeq;
   return;
elseif isequal(FN,'setorder'),
   AnaOrder = iSeq;
   return;
end

if nargin<3, Exp=1; end;
if nargin<4, testFilt=[]; end;

if iscell(iSeq),
   if ishandle(1), delete(1); end;
   if ishandle(2), delete(2); end;
   for ii=1:length(iSeq),
      [CHist, PW{ii}] = Banana(FN,iSeq{ii}, Exp, testFilt);
   end
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
      [CHist, PW] = Banana(FN,qqq, Exp, testFilt);
      pp = sgsrpar(FN, real(iSeq));
      XL = 1e-3*[0.9*min(pp.MidFreq) 1.1*max(pp.MidFreq)]; 
      return;
   end
end


spt = [];
for iseq=iSeq,
   if ~isreal(iseq), % imag part is isub
      isub = imag(iseq);
   else,
      isub = 1;
   end
   dd = getSGSRdata(FN, real(iseq));
   if ~isequal('BN',upper(dd.Header.StimName)),
      error('Not a BN sequence');
   end
   spt = [spt getSpikesOfRep(isub,1,dd.SpikeTimes.spikes)]; % in ms!
   pp = sgsrpar(FN,real(iseq));
end

% fix bug in data storage A0123
try
if isequal(999,pp.Tilt),
   Advice554 = [0     4    13    18    17    15];
   Advice556 = [0     1     4     9     8     6];
   if isequal(iSeq,555),     pp.Tilt = Advice554
   elseif isequal(iSeq,557), pp.Tilt = Advice556
   else, warning('Tilt = 999?!');
   end
end
end%try
BN = prepareBNstim(pp);
Tcyc = 1e3/BN.DDfreq(isub) % exact stimulus period in ms
Ncyc = BN.Ncyc(isub);
Ncomp = pp.Ncomp;
global DEBUGdelay; if ~isempty(DEBUGdelay), spt = spt + DEBUGdelay; end;
spt = spt-Tcyc; % spikes before risetime will be negative
spt = spt(find(spt>0)); % ignore rise time
spt = spt(find(spt<=Ncyc*Tcyc)); % ignore fall time and beyond
spt = rem(spt,Tcyc); % wrap around Tcyc
% histo
DT = 1e3/BN.Fsam(isub); % sample period in ms for histogram
Edges = (0:BN.NsamCyc(isub))*DT;
CHist = histc(spt,Edges);
if isempty(CHist), % histc is empty - shouldn't be
   CHist = Edges*0;
end
CHist(end) = []; % remove final garbage bin (see help histc)

if ~isreal(CompDelay),
   noiseLevel = imag(CompDelay);
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
Espec = ifft(CHist.^Exp);
Espec(1) = abs(Espec(2)); Nfreq = length(Espec);
if nargout>3, return; end; % no plotting

ploco = 'brgmkrgmkrgmkrgmkbrgmkrgmkrgmkrgmkbrgmkrgmkrgmkrgmk';
persistent plotColor;
if ~ishandle(2) | isempty(plotColor), plotColor=0; end;
plotColor = plotColor+1;
curco = ploco(plotColor);
plotArg = [curco '.'];
plotArgCC = [curco 'o'];
dfreq = BN.DDfreq(isub)*1e-3; % freq spacing in kHz
freqs = (0:Nfreq-1)*dfreq; % freq axis 
PowerSpec = a2db(abs(Espec)); % power spectrum of envelope
allDFs = [];
DFtriangle = zeros(pp.Ncomp,pp.Ncomp-1);
DF1 = BN.DF1(isub,:);
for ii=1:pp.Ncomp-1,
   iistr = num2str(ii);
   DF = 1+getfield(BN,['DF' iistr]); % indices of beatcomponents
   DF = DF(isub,:);
   DFi{ii} = DF;
   EE = getfield(BN,['EE' iistr]); % spectral Xcorr coeffs of corresponding beat
   EE = EE(isub,:);
   Trf{ii} = Espec(DF)./EE;
   allDFs = [allDFs, DF];
   ccc = conv(DF1,ones(1,ii));
   DFtriangle(ii,1:pp.Ncomp-ii) = ccc(ii:pp.Ncomp-1);
end
% plot(freqs,PowerSpec,[curco '.']);
% determine linear trend of background from all spectral components
MaxNspec = max(allDFs)+10; % max spectral component included in analysis
BGindex = 1:MaxNspec; % indices of background spectrum
BGindex(allDFs) = []; % remove indices of true beats
BGfreqs = freqs(BGindex);
BeatFreqs = freqs(allDFs);
BGspec = PowerSpec(BGindex); % background spectrum
BeatSpec = PowerSpec(allDFs);
LinTrend = polyfit(BGfreqs, BGspec,1);
% compensate for lin trend and plot
CompPowerSpec = PowerSpec - polyval(LinTrend, freqs);
CompBeatSpec = BeatSpec - polyval(LinTrend, BeatFreqs);
BGstd = std(BGspec);
f1; hold on; set(1, 'position',F1POS);
%[583   304   448   300]
plot(freqs,CompPowerSpec,[curco '.']);
% xplot(BeatFreqs, CompBeatSpec,[curco 'o'],'markersize',8);
xplot(BeatFreqs, CompBeatSpec,['w.']);
Mstr = '123456789ABCDEFGHIJKLMNOPQRSTUVWXXXXXXXXXXXXXXXXXXX';
for ii=1:length(DFi),
   rBeatFreq = freqs(DFi{ii});
   rBeatSpec = PowerSpec(DFi{ii});
   for jj = 1:length(DFi{ii}),
      marker = [Mstr(ii+jj)];
      rbf = rBeatFreq(jj); 
      text(rbf, rBeatSpec(jj) - polyval(LinTrend, rbf), marker, ...
         'fontsize', 8, 'color', curco);
   end
end
carIndex = 1+BN.Kfreq;
carFreqs = freqs(carIndex);
xplot(carFreqs, CompPowerSpec(carIndex),[curco 'o']);
xplot(BGfreqs, BGfreqs*0+BGstd, curco);
xplot(BGfreqs, BGfreqs*0-BGstd, curco);
xlim(dfreq*[0 MaxNspec]);
ylim([-30 30]);
grid on
xlabel('Envelope Frequency (kHz)');

allTRFs = cat(2,Trf{:});
mmm=local_XcorrMatrix(Ncomp,AnaOrder);
Ncol = size(mmm,1);
allCCs = a2db(abs(allTRFs));
allCCs = allCCs(:);
PW = mmm\allCCs(1:Ncol);
AAAA = mmm*PW;


% plot first-order analysis

PhaseFreq = BN.Kfreq(isub,:)*BN.DDfreq(isub)/1e3; % component freqs in kHz
AmpFreq = sqrt(PhaseFreq(1:end-1).*PhaseFreq(2:end)); % inbetween values
minFreq = min(PhaseFreq);
maxFreq = max(PhaseFreq);

plotFreq = 0.5*( minFreq+maxFreq + [-1 1]*1.5*(maxFreq-minFreq));
plotFreq = 0.5*[floor(2*plotFreq(1)) ceil(2*plotFreq(2)) ];
if plotFreq(1)==plotFreq(2),
   plotFreq(1) = plotFreq(1) - 0.5;
   plotFreq(2) = plotFreq(2) + 0.5;
end
if ishandle(2), f2; oldXL = xlim; else, oldXL = [inf, -inf]; end;
plotFreq(1) = min(plotFreq(1),oldXL(1));
plotFreq(2) = max(plotFreq(2),oldXL(2));

f2; set(2,'position', F2POS);
subplot(3,1,1); % ampl
MXGain = max(PW);
xplot(AmpFreq,p2db(abs(Trf{1}))-MXGain, [curco 'x']);
xplot(PhaseFreq,PW-MXGain, [curco '-']);
xlim(plotFreq);
ylabel('Gain (dB)');
title(['Comp delay = ' num2str(CompDelay) '  Order of Gain analysis = ' num2str(AnaOrder)]);


subplot(3,1,2); % phase
dph = [0 -angle(Trf{1})]; % phase differences in radians
compPhase = 2*pi*(real(CompDelay)*PhaseFreq);
ph = unwrap((cumsum(dph) + compPhase)) /2/pi; % rad->cyc
ph = ph-ph(ceil(end/2));
xplot(PhaseFreq, ph, ['-' plotArg]);
ylabel('Phase (cycles)');
% title(strvcat(' ',' ',['delay = ' CompDelay  ' ms']));
xlim(plotFreq);
grid on

subplot(3,1,3); % confidence weights
ww = local_SpecWeights(BN.Kfreq(isub,:), allDFs, CompBeatSpec, BGstd);
xplot(freqs(BN.Kfreq(isub,:)),ww, ['x-' curco]);
xlim(plotFreq);
ylabel('Confidence in estimate)');
xlabel('Freq (kHz)');
YL = ylim;
grid on;
ylim([0 YL(2)]);


% advise
advice = p2db(abs(Trf{1}));
advice = [advice(1) 0.5*(advice(1:end-1)+advice(2:end)) advice(end)];
advice = round(advice);
advice = advice - min(advice)
global LastAdvice
LastAdvice = advice;

%--------------------
function m=local_XcorrMatrix(N, maxDist);
m = [];
if nargin<2, maxDist = 0; end
if maxDist==0, maxDist = N-1; end
for dist=1:maxDist,
   for offset=1:N-dist,
      newRow = zeros(1,N);
      newRow(offset+[0, dist]) = 1;
      m = [m; newRow];
   end
end

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




