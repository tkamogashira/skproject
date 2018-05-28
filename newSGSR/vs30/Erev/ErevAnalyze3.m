function [XC, ff, sel, DC, SC] = ErevAnalyze3(DataFile, iSeq, iSubseq, binwidth, BW);
% ErevAnalyze - quick revcor analysis
if nargin<1, DataFile=''; end;
if nargin<2, iSeq=inf; end;
if nargin<3, iSubseq=1; end;
if nargin<4, binwidth=0.1; end; % 0.1-ms bin with
global SMS SD

if length(iSubseq)>1, % recursive call; add separate XCs
   XC = 0;
   for ii=iSubseq(:)',
      XC = XC + ErevAnalyze3(DataFile, iSeq, ii, binwidth);
   end
   return;
end

oldRevCor = 0;
if any(iSeq<0),
   error('no old-style revcor');
end
spt = [];

% collect spike times from all seqs
for iii=iSeq,
   Data = getSGSRdata(DataFile,iii);
   spt = [spt, getspikesofrep(iSubseq,1,Data.SpikeTimes.spikes)]; % spike times im ms
end
spt = sort(spt);
Nspikes = length(spt)
% get complex stimulus
Cstim = ErevRetrieveCstim(DataFile,iSeq(1));
Cstim = Cstim(iSubseq);

if nargin<5, BW = Cstim.NoiseBW; end

% fold
% consider spike times from end of adapt time only
spt = spt - Cstim.AdaptDur;
spt = spt(find(spt>0));
spt = spt(find(spt<Cstim.TotDur));
spt = rem(spt,4*Cstim.CycDur);
Nbin = length(Cstim.Cnoise); % FOUR noise cycles
% Nhan = round(0.5*Nbin*binwidth/Cstim.CycDur); % # samples in averaging window
Nhan = 1; % FFT results in implicit smoothing 

SC = erevWrapSpikeTime2(spt, Cstim.CycDur, Nbin, Nhan);


lcn = length(Cstim.Cnoise);
lcn = round(lcn/4);
CN = Cstim.Cnoise(1:lcn)./Cstim.Ctone(1:lcn);
CN = CN/rms(CN);
CNtw = exp(i*linspace(0,pi/2,lcn));
CN = CN.*CNtw;

if 0, % debug stuff
   rsc = real(SC)/rms(SC);
   rcn = real(CN)/rms(CN);
   figure; plot([rsc, rsc(1:100)]); 
   xplot([rcn, rcn(1:100)],'r'); 
   xplot(lcn,rcn(lcn),'kx')
   uiwait(gcf);
end
if 0, % debug stuff
   figure; 
   plot(fftshift(a2db(abs(fft(SC)))));
   xplot(fftshift(a2db(abs(fft(CN)))),'r'); 
   uiwait(gcf);
end


N = length(CN);

FSC = fftshift(fft(SC));
FCN = fftshift(fft(CN));


XC = FSC./FCN;
fsam  = 1e3/Cstim.DT; % in Hz

ff = linspace(-fsam/2,fsam/2,N+1); 
ff = ff(1:end-1);

[dum iDC] = min(abs(ff));
[dum sel] = find((abs(ff)<BW/2));


% figure; plot(abs(XC)); uiwait(gcf)
ff = Cstim.ToneFreq + ff - 0.25*(ff(2)-ff(1));
DC = ff(iDC);




