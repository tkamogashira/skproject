function Nsamp = plotSeqDA(DBN,NoPlot,samp);

% debugging function: plots D/A as stored in DAMA at DNB for seqplay

if nargin<2, NoPlot=0; end;
chanList = dama2ml(DBN);
if nargin<3,
   samp=nan;
end

kleur = 'rg';
for ichan = 1:(length(chanList)-1),
   SMP = [];
   seqDBN = chanList(ichan);
   seq = dama2ml(seqDBN); % actual list
   nDBN = floor((length(seq)-1)./2); % # DBNs
   for iDBN=1:nDBN,
      smp = dama2ml(seq(2*iDBN-1));
      rep = seq(2*iDBN);
      for rr=1:rep, SMP = [SMP smp]; end;
   end
   Nsamp(ichan) = length(SMP);
   if NoPlot, return; end;
   if isnan(samp), plot(SMP, kleur(ichan));
   else, 
      tax = (0:Nsamp(ichan)-1)*samp*1e-3;
      plot(tax, SMP, kleur(ichan));
      xlabel('Time (ms)')
   end
   hold on;
end
hold off;




