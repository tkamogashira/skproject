%program file - 4 inputs: 2 inputs each side

function [Rin, Rmon, Rbin, Sin, Smon, Sbin] = BinBeat2(P, varargin)

%Checking input arguments
if (nargin == 7), 
    [DSipsi, Fipsi, DScontra, Fcontra, DSspon, Fspon] = deal(varargin{:});

    Nrep = min([DSipsi.nrep, DScontra.nrep, DSspon.nrep]); N = 2*floor(Nrep/2);
    
    idx = find(DSipsi.indepval == Fipsi);
    SpkTrIpsi1 = DSipsi.spt(idx, 1:2:N);
    SpkTrIpsi2 = DSipsi.spt(idx, 2:2:N);

    idx = find(DScontra.indepval == Fcontra);
    SpkTrContra1 = DScontra.spt(idx, 1:2:N);
    SpkTrContra2 = DScontra.spt(idx, 2:2:N);
    
    idx = find(DSspon.indepval == Fspon);
    SpkTrSpon1 = DSspon.spt(idx, 1:2:N);
    SpkTrSpon2 = DSspon.spt(idx, 2:2:N);
    
    Fbeat = Fcontra-Fipsi;
elseif (nargin == 6),
    [DSipsi, Fipsi, Fbeat, DSspon, Fspon] = deal(varargin{:});
    Fcontra = Fipsi + Fbeat; 

    idx = find(DSipsi.indepval == Fipsi);
    Nrep = DSipsi.nrep; N = 4*floor(Nrep/4);
    SpkTrIpsi1 = DSipsi.spt(idx, 1:4:N);
    SpkTrIpsi2 = DSipsi.spt(idx, 2:4:N);
    SpkTrContra1 = TimeWarp(DSipsi.spt(idx, 3:4:N), Fipsi, Fcontra);
    SpkTrContra2 = TimeWarp(DSipsi.spt(idx, 4:4:N), Fipsi, Fcontra);
    
    idx = find(DSspon.indepval == Fspon);
    SpkTrSpon1 = DSspon.spt(idx, 1:4:N);
    SpkTrSpon2 = DSspon.spt(idx, 2:4:N);
end
    
%Extracting vector strength from input spiketrains
SIi1 = CalcPRDH(SpkTrIpsi1, 'anwin', P.anwin, 'binfreq', Fipsi);
Rin(1) = SIi1.hist.r; Sin(1) = SIi1.hist.raysign;
SIi2 = CalcPRDH(SpkTrIpsi2, 'anwin', P.anwin, 'binfreq', Fipsi);
Rin(2) = SIi2.hist.r; Sin(2) = SIi2.hist.raysign;
SIc1 = CalcPRDH(SpkTrContra1, 'anwin', P.anwin, 'binfreq', Fcontra);
Rin(3) = SIc1.hist.r; Sin(3) = SIc1.hist.raysign;
SIc2 = CalcPRDH(SpkTrContra2, 'anwin', P.anwin, 'binfreq', Fcontra);
Rin(4) = SIc2.hist.r; Sin(4) = SIc2.hist.raysign;

%Extracting vector strength from mso-cell(MODEL) while monaurally stimulated
P.ninputs = 2;
SpkOutMi1 = SNModel(P, SpkTrIpsi1, SpkTrSpon1);
SMi1 = CalcPRDH(SpkOutMi1, 'anwin', P.anwin, 'binfreq', Fipsi);
Rmon(1) = SMi1.hist.r; Smon(1) = SMi1.hist.raysign;
SpkOutMi2 = SNModel(P, SpkTrIpsi2, SpkTrSpon2);
SMi2 = CalcPRDH(SpkOutMi2, 'anwin', P.anwin, 'binfreq', Fipsi);
Rmon(2) = SMi2.hist.r; Smon(1) = SMi2.hist.raysign;
SpkOutMc1 = SNModel(P, SpkTrContra1, SpkTrSpon1);
SMc1 = CalcPRDH(SpkOutMc1, 'anwin', P.anwin, 'binfreq', Fcontra);
Rmon(3) = SMc1.hist.r; Smon(3) = SMc1.hist.raysign;
SpkOutMc2 = SNModel(P, SpkTrContra2, SpkTrSpon2);
SMc2 = CalcPRDH(SpkOutMc2, 'anwin', P.anwin, 'binfreq', Fcontra);
Rmon(4) = SMc2.hist.r; Smon(4) = SMc2.hist.raysign;

%Extracting vector strength from mso-cell(MODEL) while binaurally stimulated
P.ninputs = 4;
SpkOutBin = SNModel(P, SpkTrIpsi1, SpkTrIpsi2, SpkTrContra1, SpkTrContra2);
SBi = CalcPRDH(SpkOutBin, 'anwin', P.anwin, 'binfreq', Fipsi);
Rbin(1) = SBi.hist.r; Sbin(1) = SBi.hist.raysign;
SBc = CalcPRDH(SpkOutBin, 'anwin', P.anwin, 'binfreq', Fcontra);
Rbin(2) = SBc.hist.r; Sbin(2) = SBc.hist.raysign;
SBb = CalcPRDH(SpkOutBin, 'anwin', P.anwin, 'binfreq', Fbeat);
Rbin(3) = SBb.hist.r; Sbin(3) = SBb.hist.raysign;

%Plot information
AnDur = abs(diff(P.anwin));
figure; subplot(4, 4, 1); 
bar(SIi1.hist.bincenters, SIi1.hist.rate, 1);
title('Ipsilateral inputs PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rin(1)); sprintf('p = %.3f', Sin(1)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', anwin(SpkTrIpsi1, P.anwin)))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 2); 
bar(SIi2.hist.bincenters, SIi2.hist.rate, 1);
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rin(2)); sprintf('p = %.3f', Sin(2)); ...
      sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', anwin(SpkTrIpsi2, P.anwin)))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 3); 
bar(SIc1.hist.bincenters, SIc1.hist.rate, 1);
title('Contralateral inputs PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rin(3)); sprintf('p = %.3f', Sin(3)); ...
      sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', anwin(SpkTrContra1, P.anwin)))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 4); 
bar(SIc2.hist.bincenters, SIc2.hist.rate, 1);
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rin(4)); sprintf('p = %.3f', Sin(4)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', anwin(SpkTrContra2, P.anwin)))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 5);
bar(SMi1.hist.bincenters, SMi1.hist.rate, 1);
title('Ipsilateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rmon(1)); sprintf('p = %.3f', Smon(1)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', SpkOutMi1))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 6); 
bar(SMi2.hist.bincenters, SMi2.hist.rate, 1);
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rmon(2)); sprintf('p = %.3f', Smon(2)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', SpkOutMi2))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 7);
bar(SMc1.hist.bincenters, SMc1.hist.rate, 1);
title('Contralateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rmon(3)); sprintf('p = %.3f', Smon(3)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', SpkOutMc1))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 4, 8); 
bar(SMc2.hist.bincenters, SMc2.hist.rate, 1);
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rmon(4)); sprintf('p = %.3f', Smon(4)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', SpkOutMc2))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 2, 5); 
bar(SBi.hist.bincenters, SBi.hist.rate, 1);
title('Ipsilateral binaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rbin(1)); sprintf('p = %.3f', Sbin(1)); ...
   sprintf('Rate = %.0fspk/sec', 1000*mean(cellfun('length', SpkOutBin))/AnDur)}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 2, 6); 
bar(SBc.hist.bincenters, SBc.hist.rate, 1);
title('Contralateral binaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rbin(2)); sprintf('p = %.3f', Sbin(2))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

subplot(4, 2, 7); 
bar(SBb.hist.bincenters, SBb.hist.rate, 1);
title('Binaural beat MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(0, 1, {sprintf('R = %.3f', Rbin(3)); sprintf('p = %.3f', Sbin(3))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'left');

Hdl = subplot(4, 2, 8); set(Hdl, 'visible', 'off');
Txt = {sprintf('Ii * Ic = %.3f', prod(Rin)); ...
       sprintf('Mi * Mc = %.3f', prod(Rmon)); ...
       sprintf('Bi * Bc = %.3f', prod(Rbin(1:2))); ...
       sprintf('Bb = %.3f', Rbin(3))};
text(0.5, 0.5, Txt, 'units', 'normalized', 'verticalalignment', 'middle', 'horizontalalignment', 'center');

%---------------------------------------------------------------------------
function SpkOut = TimeWarp(SpkIn, OldFreq, NewFreq)

OldPeriod = 1000/OldFreq; NewPeriod = 1000/NewFreq;

if ~iscell(SpkIn), SpkIn = {SpkIn}; end; N = length(SpkIn);
for n = 1:N, SpkOut{n} = (SpkIn{n}/OldPeriod)*NewPeriod; end

%---------------------------------------------------------------------------