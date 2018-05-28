function XC = ErevAnalyze(DataFile, iSeq, iSubseq, binwidth, jitter,Nrep);
% ErevAnalyze - do revcor analysis
if nargin<1, DataFile=''; end;
if nargin<2, iSeq=inf; end;
if nargin<3, iSubseq=1; end;
if nargin<4, binwidth=1; end; % 1-ms bin with
if nargin<5, jitter=0; end;
if nargin<6, Nrep=1; end;

if length(iSubseq)>1,
   XC = 0;
   for ii=iSubseq(:)',
      XC = XC + ErevAnalyze(DataFile, iSeq, ii, binwidth, jitter,Nrep);
      aa;
   end
   return;
end

global SMS SD

if ischar(DataFile),
   spt = [];
   for iii=iSeq,
      Data = getSGSRdata(DataFile,iii);
      SMS = Erev2SMS(Data.Header.StimParams,1);
      spt = [spt, Data.SpikeTimes.SubSeq{iSubseq}.Rep{1}]; % spike times im ms
   end
   spt = sort(spt);
   if ~isequal(0,jitter),
      spt = sort(spt+jitter*randn(size(spt)));
   end
   sim = 0;
else,
   SMS = Erev2SMS(DataFile,1);
   sim = (length(iSeq)>1);
   FF = iSeq; % bandpass filter for simulations
end
% plot(spt)
% reconstruct the stimulus, now using fake calibration
clear sms2prp; % force re-computation of stimuli
sms2prp(0,1); % second arg: save to samplelib; not AP2

iwv = max(SD.subseq{iSubseq}.ipool);
wv = SD.waveform{iwv};
[qq Ctone Cnoise DT] = stimgenErev(wv,'nowhere'); % no storage
DT = DT*1e-3; % us->ms

AdaptDur = SMS.BOTH.Adapt;
CycDur = SMS.NOISE.dur;
TotDur = SMS.NOISE.Ncyc*CycDur; % excluding offset ramp & adapt time
% figure; plot(spt)

% bin the spike times
Nbins = 4*round(CycDur/binwidth)
binwidth = 4*CycDur/Nbins;
Edges = binwidth*(0:Nbins);

% fold
if ~sim,
   % consider spike times from end of adapt time only
   spt = spt - AdaptDur;
   spt = spt(find(spt>0));
   spt = spt(find(spt<TotDur));
   spt = rem(spt,4*CycDur);
   SC = histc(spt,Edges);
else,
   Env = abs(filter(FF,1,Cnoise+Ctone));
   AVrate = 300;
   ETotNspike = Nrep*SMS.NOISE.Ncyc*1e-3*CycDur*AVrate;
   Env = Env/mean(Env);
   NN = length(Env);
   AvSpikePerSample = ETotNspike/NN;
   Nrr = ceil(10*AvSpikePerSample);
   SC = Edges*0;
   Nsp = 0;
   for nn=1:Nrr,
      spt = DT*find(rand(1,NN)< Env*AvSpikePerSample/Nrr);
      Nsp = Nsp + length(spt);
      SC = SC + histc(spt,Edges);
   end
   % figure; plot(spt);
end

SC = SC(1:end-1); % last histc comp is nonsense
Twist=exp(i*linspace(0,2*pi,Nbins));
SC = SC.*Twist;
SC = sum(reshape(SC(:),[Nbins/4 4]),2);
SC = SC(:).';
SC = SC./Twist(1:Nbins/4);
SC = SC/rms(SC);
bb = binwidth*(0.5+(1:Nbins/4));
size(bb)
% figure; plot(bb,5*abs(SC),bb,unwrap(angle(SC)))

lcn = length(Cnoise);
lcn = round(lcn/4);
CN = Cnoise(1:lcn)./Ctone(1:lcn);
CN = CN/rms(CN);
tt = linspace(0,max(bb),lcn);
% figure; rget; ggmove(1,0,400); plot(tt,5*abs(CN),tt,unwrap(angle(CN)));

SC = resample(SC,lcn,length(bb));
XC = xcorr(SC,CN,'coeff');

figure; plot(abs(XC))






