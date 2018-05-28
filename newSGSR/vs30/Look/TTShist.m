function y=TTShist(FN,iSeq,isub, plotArg);
% TTShist - histogram(s) of TTS data

if nargin<1, FN = []; end;
if nargin<2, iSeq = []; end
if nargin<4, plotArg = 'b'; end

if length(isub)>1, % recursive call, obligatory colors
   % clf;
   for ii = 1:length(isub),
      TTShist(FN,iSeq,isub(ii), ploco(ii));
   end
   return
end

[FN, iSeq] = DataIdent(FN, iSeq, nargin);
% get the dataset
ds = dataset(FN, iSeq);

Fp = ds.CarFreq; % probe freq in Hz
Fs = ds.ModFreq; % suppr freq in Hz

Tsup = 1e3/Fs; % suppr cycle
Tprobe = 1e3/Fp; % probe cycle
NN = round(Tsup/Tprobe);
Tmin = Tsup; % min spike time in ms
Tmax = Tsup*(floor(ds.burstdur/Tsup)); % idem max


spt = ds.spt;
spt = cat(2, spt{isub,:});
spt = spt(find((spt>Tmin)&(spt<=Tmax))); % spikes occurring well within burst
spt = rem(spt, Tsup); % spike times modulo the suppressor cycle




Edges = (0:NN)*Tprobe;
t = Edges(1:end-1)+Tprobe/2;
CH = histc(spt, Edges); CH(end) = [];
subplot(3,1,1);
xplot(t, CH, [plotArg '*-'])
% -----phase re probe
subplot(3,1,2);
Zphase = exp(2*pi*i*spt/Tprobe); % phase of spikes re probe cycle 
for ii=1:NN,
   icyc{ii} = find((spt>=Edges(ii))&(spt<Edges(ii+1)));
   phAv(ii) = angle(sum(Zphase(icyc{ii})))/2/pi; % in cycles
end
xplot(t, phAv, [plotArg '*-']);
ylim([-0.5 0.5]);
%subplot(3,1,3);
%for ii=1:NN,
%   ic = icyc{ii};
%   xplot(angle(Zphase(ic))/2/pi, ii, ['.' plotArg]);
%end










