function [effstim, SPT, iSPT, dataInfo] = PolarSpikePlot(DF, AA, plotArg, Compression, PhaseRot);
% PolarSpikePlot - polar dot raster of zwuis stimulus
%  syntax:
%   [effstim, SPT, iSPT, dataInfo] = PolarSpikePlot(DF, Apset, plotArg, Compression, PhaseRot);
%   (DF,Apset) may also be (Apstr,icurve)
%  Examples
%    
if nargin<3, plotArg='n'; end
if nargin<4, Compression = 1; end % dB/dB growth fnc
if nargin<5, PhaseRot = 0; end % no ratation

if isnumeric(AA), % PolarSpikePlot('307/50', [2 3], ...) syntax. Convert.
   AA = getAppleset(DF,AA);
   DF = ['A0' DF(1:3)];
end

Iseq = AA.iSeq;

%==reconstruct detailed stimulus parameters
%
ds = dataset(DF,Iseq(1));
% first make sure that sam freqs match those of recordings (inelegant)
global SGSR; oldSGSR = SGSR;
SGSR.samFreqs = ds.settings.RecordParams.samFreqs;
CDuseCalib('', 'B'); % make sure no calibration is imposed
BN = prepareBNstim(ds.spar); 
% save memory: remove specrea and complex waveform of BN stim - we need only *filtered* version here anyhow
[BN.SpecL, BN.SpecR BN.CWaveL BN.CWaveR] = deal([]);
SGSR = oldSGSR; % restore SGSR global
% the following params suffice to compute one cycle of the uncalibrated stimulus:
Nsam = BN.NsamCyc;
AmpC = BN.EE0; % complex amplitudes of tones
AmpC = AmpC/max(abs(AmpC)); % normalize: largest cmp ~ 1
Scale = db2A(Compression*AA.SPL(1))/abs(AmpC(1));
AmpC = AmpC*Scale; % normalize: 0 dB ~ unity amp
Ntone = length(AmpC);
Fsam = BN.Fsam; % in Hz
FcarRPS = 2*pi*BN.Kfreq*BN.DDfreq/Fsam; % carrier freqs in radians per sample
CycDur = 1e3*Nsam/BN.Fsam; % duration of cycle in ms

%==apply the transfer function from AA to the stimulus
AmpC = AmpC.*AA.TRF/max(abs(AA.TRF)); % normalization: peak of trf fnc has unity gain
isig = find(AA.RScar<0.0011);

% construct the effective stimulus
effstim = 0;
samrange = 0:Nsam-1;
for itone=isig(:)', % only take the sigificant components
   effstim = effstim + AmpC(itone)*exp(i*FcarRPS(itone)*samrange);
end

% pool spikes from all datasets
Nseq = length(Iseq);
SPT = []; 
AnaWin = CycDur*[1 BN.Ncyc-1]; % omit onset and offset ramps
icount = 0;
for iseq = Iseq(:)',
   icount = icount + 1;
   ds = dataset(DF,iseq);
   spt = Anwin(ds,AnaWin);
   SpkData(icount) = collectInStruct(iseq, spt);
   SPT = [SPT spt{1,1}]; % pool all spikes
end

% where are the spikes in the stimulus cyclus?
SPT = 1e-3*mod(SPT, CycDur); % in seconds
%dsiz(SPT)
% what index of the stimulus do the spikes correspond to?
iSPT = 1+floor(SPT*Fsam);

Nspike = length(iSPT);
NspikePerSeq = round(Nspike/Nseq)


dataInfo = collectInStruct(DF, CycDur, BN, effstim, Iseq, Nspike, NspikePerSeq, SpkData, iSPT, AmpC, Fsam);

% apply rotation
effstim = effstim*exp(2*pi*i*PhaseRot);
%plot(iSPT,'.');



f2; pla = plotArg; 

subplot(2,2,1); if isequal('n',pla), pla='b'; cla; end
[Nstim, X] = hist(real(effstim(:)),30);
DX = diff(X(1:2));
Nresp = hist(real(effstim(iSPT)),X);
NormFac = 1/Nseq/DX;
IOplot(X, Nresp, Nstim, NormFac, [pla 'o-'], 'markerfacecolor', pla);

subplot(2,2,2); if isequal('n',pla), pla='b'; cla; end
[Nstim, X] = hist(abs(effstim(:)),30);
DX = diff(X(1:2));
Nresp = hist(abs(effstim(iSPT)),X);
NormFac = 1/Nseq/DX;
IOplot(X, Nresp, Nstim, NormFac, [pla 'o-'], 'markerfacecolor', pla);

subplot(2,2,3); if isequal('n',pla), pla='b'; cla; end
[Nstim, X] = hist(real(effstim(:)),30);
DX = diff(X(1:2));
% split stim into pos and neg phase
iup = find(imag(effstim)<0); % rising phase
ido = find(imag(effstim)>=0);
NstimU = hist(real(effstim(iup)),X);
NstimD = hist(real(effstim(ido)),X);
% idem for response
resp = effstim(iSPT);
iup = find(imag(resp)<0); % rising phase
ido = find(imag(resp)>=0);
NrespU = hist(real(resp(iup)),X);
NrespD = hist(real(resp(ido)),X);
NormFac = 1/Nseq/DX;
IOplot(X, NrespU, NstimU, NormFac, [pla '^-'], 'markerfacecolor', 'w');
IOplot(X, NrespD, NstimD, NormFac, [pla 'v-'], 'markerfacecolor', pla);

subplot(2,2,4); if isequal('n',pla), pla='b'; cla; end

figure(gcf); drawnow;
[Nstim, X] = hist(abs(effstim(:)),30);
IOplot(X, Nstim, X, 1, [pla 's-'], 'markerfacecolor', pla);

AreaFactor = Nstim./X; % normalization factor for 2D dot raster below
Xcomp = cumsum(AreaFactor);
Xcomp = [0 Xcomp Xcomp(end)];
dots = effstim(iSPT); % complex value of eff stim at spike times
Env = abs(dots);
CompEnv = interp1([0 X 2*max(X)], Xcomp, Env);
dots = dots./Env.*CompEnv;

f1; pla = plotArg; if isequal('n',pla), pla='b'; clf; end
% dsiz(effstim), [MINi MAXi] = minmax(iSPT)
xplot(dots, [pla '.'], 'markersize', 2, 'linestyle', 'none');
figure(gcf); drawnow;
MX = max(abs(effstim));
% xlim(MX*[-1 1]); ylim(MX*[-1 1]);
axis square;
axis equal

f3; set(gcf,'position', [760 130 448 300]);
spokeplot(effstim, iSPT, 24, 10)

f2;







