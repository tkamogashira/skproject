function poincare(DFN, iSeq, Nshift, maxDT);
% poincare - poincare plot of spikes

if nargin<3, Nshift = 1; end; % distance between intervals
if nargin<4, maxDT = 10; end; % ms max plotted isi



% pool isis
intervals = [];
for iseq = iSeq(:)',
   ds = dataset(DFN, iseq);
   spt = ds.spt{1,1};
   dspt = diff(spt);
   intervals = [intervals dspt(2:end) nan];
end
figure(gcf);
plot(intervals(1:end-Nshift), intervals(1+Nshift:end),'.');
xlim([0 maxDT]);
ylim([0 maxDT]);
xlabel('ISI (ms)');
ylabel('subsequent ISI (ms)');
title(['distance: ' num2str(Nshift) ' intervals.']);


