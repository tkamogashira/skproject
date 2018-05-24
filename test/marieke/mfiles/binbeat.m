%program file - 2 inputs: 1 each side

function [Rin, Rmon, Rbin, Sin, Smon, Sbin] = BinBeat(P, varargin)

%Checking input arguments
if (nargin == 7), 
    [DSipsi, Fipsi, DScontra, Fcontra, DSspon, Fspon] = deal(varargin{:});
    
    idx = find(DSipsi.indepval == Fipsi);     SpkTrIpsi   = DSipsi.spt(idx, :);
    idx = find(DScontra.indepval == Fcontra); SpkTrContra = DScontra.spt(idx, :);
    idx = find(DSspon.indepval == Fspon);     SpkTrSpon   = DSspon.spt(idx, :);    
    
    Fbeat = Fcontra-Fipsi;
elseif (nargin == 6),
    [DSipsi, Fipsi, Fbeat, DSspon, Fspon] = deal(varargin{:});
    Fcontra = Fipsi + Fbeat; 

    idx = find(DSipsi.indepval == Fipsi);
    Nrep = DSipsi.nrep; N = 2*floor(Nrep/2);
    SpkTrIpsi = DSipsi.spt(idx, 1:2:N);
    SpkTrContra = TimeWarp(DSipsi.spt(idx, 2:2:N), Fipsi, Fcontra);
    
    idx = find(DSspon.indepval == Fspon); SpkTrSpon = DSspon.spt(idx, 1:N/2);
end
    
%Extracting vector strength from input spiketrains
SIi = CalcPRDH(SpkTrIpsi, 'anwin', P.anwin, 'binfreq', Fipsi);
Rin(1) = SIi.hist.r; Sin(1) = SIi.hist.raysign;
SIc = CalcPRDH(SpkTrContra, 'anwin', P.anwin, 'binfreq', Fcontra);
Rin(2) = SIc.hist.r; Sin(2) = SIc.hist.raysign;

%Extracting vector strength from mso-cell(MODEL) while monaurally stimulated
SpkOut = SNModel(P, SpkTrIpsi, SpkTrSpon);
SMi = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', Fipsi);
Rmon(1) = SMi.hist.r; Smon(1) = SMi.hist.raysign;
SpkOut = SNModel(P, SpkTrContra, SpkTrSpon);
SMc = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', Fcontra);
Rmon(2) = SMc.hist.r; Smon(2) = SMc.hist.raysign;

%Extracting vector strength from mso-cell(MODEL) while binaurally stimulated
SpkOut = SNModel(P, SpkTrIpsi, SpkTrContra);
SBi = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', Fipsi);
Rbin(1) = SBi.hist.r; Sbin(1) = SBi.hist.raysign;
SBc = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', Fcontra);
Rbin(2) = SBc.hist.r; Sbin(2) = SBc.hist.raysign;
SBb = CalcPRDH(SpkOut, 'anwin', P.anwin, 'binfreq', Fbeat);
Rbin(3) = SBb.hist.r; Sbin(3) = SBb.hist.raysign;

%Plot information
figure; subplot(4, 2, 1); 
bar(SIi.hist.bincenters, SIi.hist.rate, 1);
title('Ipsilateral input PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rin(1)); sprintf('p = %.3f', Sin(1))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 2); 
bar(SIc.hist.bincenters, SIc.hist.rate, 1);
title('Contralateral input PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rin(2)); sprintf('p = %.3f', Sin(2))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 3); 
bar(SMi.hist.bincenters, SMi.hist.rate, 1);
title('Ipsilateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rmon(1)); sprintf('p = %.3f', Smon(1))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 4); 
bar(SMc.hist.bincenters, SMc.hist.rate, 1);
title('Contralateral monaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rmon(2)); sprintf('p = %.3f', Smon(2))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 5); 
bar(SBi.hist.bincenters, SBi.hist.rate, 1);
title('Ipsilateral binaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rbin(1)); sprintf('p = %.3f', Sbin(1))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 6); 
bar(SBc.hist.bincenters, SBc.hist.rate, 1);
title('Contralateral binaural MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rbin(2)); sprintf('p = %.3f', Sbin(2))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

subplot(4, 2, 7); 
bar(SBb.hist.bincenters, SBb.hist.rate, 1);
title('Binaural beat MSO PRDH');
xlabel('Phase (cycles)'); xlim([0 1]);
ylabel('Rate (spk/sec)');
text(1, 1, {sprintf('R = %.3f', Rbin(3)); sprintf('p = %.3f', Sbin(3))}, 'units', 'normalized', 'verticalalignment', 'top', 'horizontalalignment', 'right');

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