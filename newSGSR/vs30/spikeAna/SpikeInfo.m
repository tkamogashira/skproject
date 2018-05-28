function spikeInfo(ds, isub, Nmax, plotArg)
% spikeInfo timing info of spiketrains to repeated stimulus
%   SpikeInfo plots a measure of the flatness of the PST 
%   at different timescales.

if nargin<2,isub = 0; end
if nargin<3,Nmax = []; end
if nargin<4,plotArg = 'n'; end

if isempty(Nmax), Nmax = 20; end
Fake = (Nmax<0); Nmax = abs(Nmax);

if isequal(0,isub), isub=1:ds.nrec; end % all recorded subsequences

Nsub = length(isub);
if Nsub>1, % multiple seqs: use recursion
   plotArg = ['n' ploco(2:Nsub)];
   for ii=1:Nsub,
      spikeInfo(ds, isub(ii), Nmax, plotArg(ii));
   end
   return
end

spt = Anwin(ds); % select spiketimes during stimulus burst
spt = spt(isub,:); % now each cell is spiketrain of singe rep
spt = [spt{:}]; % pool all spikes of different reps
Dur = ds.burstdur;
if Fake, spt = Dur*rand(size(spt)); end

% histogram at maximal resolution
Nint = 2^Nmax;
Edges = linspace(0,Dur,Nint+1);
Freq = histc(spt, Edges); Freq(end) = []; % delete last garbage bin

for ii=1:Nmax,% use coarser bins by joining the fine ones
   freq = reshape(Freq, 2^ii, 2^(Nmax-ii));
   freq = sum(freq,2); 
   freq = freq/sum(freq); % normalize
   NBit(ii) = ii+sum(freq.*log2(1e-10+freq)); % NBit=0 -> flat distr
   TimeScale(ii) = Dur/2^ii;
end

figure(gcf);
xplot(TimeScale, NBit, plotArg);
set(gca,'xscale', 'log');
drawnow;











