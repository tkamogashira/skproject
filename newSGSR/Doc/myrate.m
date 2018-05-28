function myrate(ds)
% MYRATE - spike rate plot for datasets
%    MYRATE(DS) produces a spike rate plot for dataset DS.
%    Only spikes that occur within the burst duration are counted.

if isequal('THR', ds.stimtype), 
   error('Cannot plot spike rate plot for THR datasets');
elseif isnan(ds.burstdur),
   error('Dataset does not have a well-defined burst duration.');
end;

SPT = AnWin(ds); % restrict to spikes within burstdur
Nspike = zeros(1,ds.nsub); % row vector of the right length
for isub = 1:ds.nrec,
   Nspike(isub) = length([SPT{isub,:}]);
end
TotDur = ds.burstdur*ds.nrep; % total net duration of spike window
Rate = 1e3*Nspike/TotDur; % 1e3 converts ms -> s 
plot(ds.xval, Rate, '*-')
set(gca, 'Xscale', ds.x.PlotScale);
xlabel(ds.xlabel);
ylabel('Spike rate (sp/s)');
title([ds.filename ' seq ' num2str(ds.iseq) ' <' ds.stimtype '>']);
