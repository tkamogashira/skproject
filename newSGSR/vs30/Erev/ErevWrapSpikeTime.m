function [spt, E] = ErevWrapSpikeTimes(DataFile, iSeq, iSubseq, binwidth);
% ErevWrapSpikeTimes
if nargin<1, DataFile=''; end;
if nargin<2, iSeq=inf; end;
if nargin<3, iSubseq=1; end;
global SMS SD

if ischar(DataFile),
   spt = [];
   for iii=iSeq,
      Data = getSGSRdata(DataFile,iii);
      SMS = Erev2SMS(Data.Header.StimParams,1,1); % 2nd arg: fake cal; 3rd arg: force computation
      spt = [spt, Data.SpikeTimes.SubSeq{iSubseq}.Rep{1}]; % spike times im ms
   end
   spt = sort(spt);
end
Nspikes = length(spt);

% timing parameters
AdaptDur = SMS.BOTH.Adapt;
CycDur = SMS.NOISE.dur;
TotDur = SMS.NOISE.Ncyc*CycDur; % excluding offset ramp & adapt time

% consider spike times from end of adapt time only
spt = spt - AdaptDur;
spt = spt(find(spt>0));
spt = spt(find(spt<TotDur));
% fold and sort
spt = rem(spt,4*CycDur);
spt = sort(spt);
% over-bining
NN = 12*Nspikes
Edges = linspace(0,4*CycDur,NN+1);
E = histc(spt, Edges); E(end) = [];
% smoothing
Nhan = round(NN*binwidth/CycDur)
E = conv([E,E,E],hanning(Nhan));
E = E(NN+round(Nhan/2)-1+(1:NN));
E = E.*exp(2*pi*i*(1:NN)/NN);
% folding
E = reshape(E,NN/4,4).';
E = sum(E,1);

% smoothing


