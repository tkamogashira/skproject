function Y = CDTphase(FN, iSeq, cdelay, plotArg);
% CDTphase - process CDT phases in LF, 3-tone, zwuis data

if nargin<3, cdelay = 1; end
if nargin<4, plotArg = 'n'; end

RC = 0.001; % Rayleigh criterium
%----------------------------------------------

if iscell(iSeq),
   Nseq = length(iSeq);
   plotArgs = ploco(1:Nseq);
   plotArgs(1) = 'n'; % new plot
   for ii=1:Nseq,
      iseq = iSeq{ii};
      if ischar(iseq), continue; end
      CDTphase(FN, iseq, cdelay, plotArgs(ii));
   end
   global LastGrapeArg 
   LastAppleArg = iSeq;
   LastGrapeArg = LastAppleArg;
   return
end

% ======= single spike set from here ==========

% get data, compute cycle histogram and its spectrum
chs = BNhisto(FN, iSeq, 'BNhisto'); % last arg is cache file name
CurrentIcell = chs.iCell;
% bookkeeping variables
BN = chs.BN; if iscell(BN), BN=BN{1}; end; % assuming different elements are equivalent
df = BN.DDfreq; % minimum spacing step of components
Kfreq = BN.Kfreq; % carrier freqs as multiples of df
Ncar = length(Kfreq);
Kbeat = localBeat(Kfreq,1); % beat freqs as multiples of df
Fcar = 1e-3*df*Kfreq(:).'; % carrier freqs in kHz
Fbeat = 1e-3*df*Kbeat; % freq freqs in kHz
if Ncar~=3, warning('#primaries not equal to 3.'); end

CDTmatrix = [0 -1; 2 2; -1 0]; % lower and upper cdt from primary vector
Fcdt = Fcar*CDTmatrix;
Kcdt = Kfreq*CDTmatrix;

% stimulus
StimSpec = BN.EE0; % complex amplitudes of carriers
StimCarPhase = angle(StimSpec);
StimCDTphase = [StimCarPhase]*CDTmatrix;

% response
Nspike = chs.Nspike;
VSref = RayleighCrit(Nspike, RC); % reference vector strength needed for meeting RC above
RespSpecCar = conj(chs.CHspec(Kfreq+1)); % complex amplitudes of carrier cmps in response
RespSpecCDT = conj(chs.CHspec(Kcdt+1)); % idem CDTs
VScar = abs(chs.CHspec(Kfreq+1))/Nspike; % Vector strength of carrier components
VScdt = abs(chs.CHspec(Kcdt+1))/Nspike; % Vector strength of CDTs
RScar = RayleighSign(VScar ,Nspike); % Rayleigh significance of carrier components
RScdt = RayleighSign(VScdt, Nspike); % Rayleigh significance of CDTs
iclash = find(ismember(Kfreq, Kbeat)); % indices of carriers that coincide with beats
signCar = (RScar<=RC); % significance of carriers according to RC
signCDT = (RScdt<=RC); % significance of CDTs according to RC
% phase transfer
TRFphaseCar = delayPhase((angle(RespSpecCar)-StimCarPhase)/2/pi, Fcar, cdelay, 2);
TRFphaseCDT = delayPhase((angle(RespSpecCDT)-StimCDTphase)/2/pi, Fcdt, cdelay, 2);
% "cancellation phase"
CancelPhase = delayPhase(0.5+TRFphaseCDT - TRFphaseCar([1 3]),0,0,2);
%========PLOT=====================
f3; 
if isequal('n', plotArg), % new plot
   clf; 
   plotArg = 'b';
end
subplot(2,2,1);
xplot(1e3*Fcar, TRFphaseCar+pmask(signCar), [plotArg 'o']);
xplot(1e3*Fcdt, TRFphaseCDT+pmask(signCDT), [plotArg '*']);
xlabel('Frequency (Hz)');
ylabel('Phase (cycles)');

subplot(2,2,3);
xplot(1e3*Fcdt, CancelPhase+pmask(signCDT)+pmask(signCar([1 3])), [plotArg 'x']);
xlabel('Frequency (Hz)');
ylabel('Phase (cycles)');
grid on

subplot(2,2,2);
DF = 1e3*diff(Fcar);
xplot(DF(1), CancelPhase(1)+pmask(signCDT(1))+pmask(signCar(1)), [plotArg 'v']);
xplot(-DF(2), CancelPhase(2)+pmask(signCDT(2))+pmask(signCar(3)), [plotArg '^']);
xlabel('DF (Hz)');
ylabel('Cancel Phase (cycles)');



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


