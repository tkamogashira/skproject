function [Rin, Rmon, Rbin] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq)

idx = find(dsStim.indepval == StimFreq);
NrepsStim = dsStim.nrep; N = 2*floor(NrepsStim/2);
SpkTrIpsi   = dsStim.spt(idx, 1:2:N);
SpkTrContra = dsStim.spt(idx, 2:2:N);

idx = find(dsSpon.indepval == SponFreq);
NrepsSpon = dsSpon.nrep;
if (NrepsSpon >= NrepsStim), 
    SpkTrSponIpsi   = dsSpon.spt(idx, 1:2:N);
    SpkTrSponContra = dsSpon.spt(idx, 2:2:N);
else, [SpkTrSponIpsi, SpkTrSponContra] = deal(dsSpon.spt(idx, 1:N)); end

%Extracting vector strength from input spiketrains
SIi = CalcPRDH(SpkTrIpsi, 'anwin', P.anwin, 'binfreq', StimFreq);
Rin(1) = SIi.hist.r;
SIc = CalcPRDH(SpkTrContra, 'anwin', P.anwin, 'binfreq', StimFreq);
Rin(2) = SIc.hist.r;

%Extracting vector strength from mso-cell(MODEL) while monaurally stimulated
SpkOut = SNModel(P, SpkTrIpsi, SpkTrSponIpsi);
SMi = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', StimFreq);
Rmon(1) = SMi.hist.r;
SpkOut = SNModel(P, SpkTrContra, SpkTrSponContra);
SMc = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', StimFreq);
Rmon(2) = SMc.hist.r;

%Extracting vector strength from mso-cell(MODEL) while binaurally stimulated with
%discrete interaural time difference steps
N = length(ITDrange); Rate = zeros(1, N); AnDur = abs(diff(P.anwin));
for n = 1:N, 
    if (ITDrange > 0), Rate(n) = 1000*mean(cellfun('length', SNModel(P, TimeShift(SpkTrIpsi, ITDrange(n)/1000), SpkTrContra)))/AnDur; 
    else, Rate(n) = 1000*mean(cellfun('length', SNModel(P, SpkTrIpsi, TimeShift(SpkTrContra, abs(ITDrange(n)/1000)))))/AnDur; end    
end
%[ITDrange, idx] = unique([-ITDrange, +ITDrange]); Rate = repmat(Rate, 1, 2); Rate = Rate(idx);
Sbin = CycleHist(ITDrange/1000, Rate, AnDur, length(SpkTrIpsi), StimFreq);
Rbin = Sbin.R;

%Plotting data
figure; subplot(4, 2, 1); 
bar(SIi.hist.bincenters, SIi.hist.rate, 1);
title('Ipsilateral input PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, sprintf('R = %.3f', Rin(1)), 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 2); 
bar(SIc.hist.bincenters, SIc.hist.rate, 1);
title('Contralateral input PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, sprintf('R = %.3f', Rin(2)), 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 3); 
bar(SMi.hist.bincenters, SMi.hist.rate, 1);
title('Ipsilateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, sprintf('R = %.3f', Rmon(1)), 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 4); 
bar(SMc.hist.bincenters, SMc.hist.rate, 1);
title('Contralateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, sprintf('R = %.3f', Rmon(2)), 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 5); plot(ITDrange, Rate, '.-');
title('ITD-function');
xlabel('ITD (microsec)'); xlim([min(ITDrange), max(ITDrange)]);
ylabel('Rate (spk/sec)');

subplot(4, 2, 6); bar(Sbin.X, Sbin.Y, 1);
title('PRD-histogram');
xlabel('Phase'); xlim([0, 1]);
ylabel('Rate (spk/sec)');
text(1, 1, sprintf('R = %.3f', Rbin), 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

Hdl = subplot(4, 1, 4); set(Hdl, 'visible', 'off');
Txt = {sprintf('Ii * Ic = %.3f', prod(Rin)); ...
       sprintf('Mi * Mc = %.3f', prod(Rmon)); ...
       sprintf('Bb = %.3f', Rbin)};
text(0.5, 0.5, Txt, 'units', 'normalized', 'verticalalignment', 'middle', 'horizontalalignment', 'center');

%---------------------------------------------------------------------------
function SpkOut = TimeShift(SpkIn, Time)

if ~iscell(SpkIn), SpkIn = {SpkIn}; end; N = length(SpkIn);
for n = 1:N, SpkOut{n} = SpkIn{n}+Time; end

%---------------------------------------------------------------------------