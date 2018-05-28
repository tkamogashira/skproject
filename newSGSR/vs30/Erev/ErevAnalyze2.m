function [XC, ff, sel, DC, SC] = ErevAnalyze2(DataFile, iSeq, iSubseq, binwidth, BW);
% ErevAnalyze - do revcor analysis
if nargin<1, DataFile=''; end;
if nargin<2, iSeq=inf; end;
if nargin<3, iSubseq=1; end;
if nargin<4, binwidth=0.1; end; % 0.1-ms bin with
global SMS SD

if length(iSubseq)>1, % recursive call
   XC = 0;
   for ii=iSubseq(:)',
      XC = XC + ErevAnalyze(DataFile, iSeq, ii, binwidth);
   end
   return;
end

ignoreReject = 0;
if binwidth<0,
   ignoreReject = 1;
end
binwidth = abs(binwidth);
oldRevCor = 0;
if any(iSeq<0),
   iSeq = abs(iSeq);
   oldRevCor = 1;
end
spt = [];
for iii=iSeq,
   Data = getSGSRdata(DataFile,iii);
   if ignoreReject,
      Data.Header.StimParams.RejectAtt = 0;
   end
   SMS = Erev2SMS(Data.Header.StimParams,1,1); % 2nd arg: fake cal; 3rd arg: force computation
   spt = [spt, getspikesofrep(iSubseq,1,Data.SpikeTimes.spikes)]; % spike times im ms
end
spt = sort(spt);
Nspikes = length(spt)

if nargin<5, BW = SMS.NOISE.BW; end

% plot(spt)
% reconstruct the stimulus, now using fake calibration
clear sms2prp; % force re-computation of stimuli
sms2prp(0,1); % second arg: save to samplelib; not AP2

iwv = max(SD.subseq{iSubseq}.ipool);
wv = SD.waveform{iwv};
[qq Ctone Cnoise DT] = stimgenErev(wv,'nowhere'); % no storage
DT = DT*1e-3; % us->ms
% plot(abs(fft(Cnoise))); uiwait(gcf)

AdaptDur = SMS.BOTH.Adapt;
CycDur = SMS.NOISE.dur;
TotDur = SMS.NOISE.Ncyc*CycDur; % excluding offset ramp & adapt time
% figure; plot(spt)


% fold
% consider spike times from end of adapt time only
spt = spt - AdaptDur;
spt = spt(find(spt>0));
spt = spt(find(spt<TotDur));
spt = rem(spt,4*CycDur);
Nbin = length(Cnoise); % FOUR noise cycles
Nhan = round(0.5*Nbin*binwidth/CycDur) % # samples in averaging window

SC = erevWrapSpikeTime2(spt, CycDur, Nbin, Nhan);


lcn = length(Cnoise);
lcn = round(lcn/4);
if oldRevCor,
   CN = Cnoise(1:lcn);
else,
   CN = Cnoise(1:lcn)./Ctone(1:lcn);
end
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
fsam  = 1e3/DT; % in Hz

ff = linspace(-fsam/2,fsam/2,N+1); 
ff = ff(1:end-1);

[dum iDC] = min(abs(ff));
[dum sel] = find((abs(ff)<BW/2));


% figure; plot(abs(XC))
ff = SMS.TONE.freq + ff - 0.25*(ff(2)-ff(1));
DC = ff(iDC);




