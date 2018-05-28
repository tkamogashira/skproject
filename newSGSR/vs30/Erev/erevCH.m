function CH = erevCH(FN,iSeq,isub, binwidth,plotpar)
% EREVCH - cycle hist of erev sequence
if nargin<4, 
   binwidth=0.1; % ms
end
if nargin<5, 
   plotpar = 'n'; % new plot
end

% stim params


% crunch the numbers
spt = [];
for iseq=iSeq,
   Nsub = sgsrNsubRec(FN,iseq);
   pp = sgsrpar(FN,iseq);
   TotDur = 1e3*pp.TotDur; % s -> ms
   CycDur = pp.NoiseDur; % duration of a noise cycle
   dd = getSGSRdata(FN,iseq);
   spt = [spt getSpikesOfRep(isub,1,dd.SpikeTimes.spikes)]; % in ms!
end
spt = spt - pp.AdaptDur;
spt = spt(find(spt>0));
spt = spt(find(spt<TotDur));
spt = rem(spt,4*CycDur);
Nspikes = length(spt)
Nbin = round(4*CycDur/binwidth)
Edges = linspace(0,4*CycDur,Nbin+1);
CH = histc(spt, Edges); 
CH(end) = []; 
Edges(end) = [];
%plotbar(Edges,sqrt(H), 'histc');
%xlim([0 max(Edges)]);
if nargout<1,
   xplot(Edges,CH,plotpar);
end
