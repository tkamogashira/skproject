function [BC, AllCorr, Tau, Freq, AllSpec, DomPers, MaxCross] ...
   = Shama(DFN, dsid1, dsid2, maxlag, binwidth);
% SHAMA - correlation analysis across two fibres
MaxFreq = 5e3; % Hz max freq of spectrum considered

% default values
if nargin<4,  maxlag=20; end; % 20-ms max delay in xcorr fnc
if nargin<5,  binwidth=0.05; end; % 50-us  bin width

% read datasets
[ds1, burstdur1, rp1, rm1] = localGetData(DFN, dsid1);
[ds2, burstdur2, rp2, rm2] = localGetData(DFN, dsid2);
if ~isequal(burstdur1, burstdur2),
   warning('Datasets have unequal burst durations.')
end
if any([ds1.nsub ds1.nrec] ~= [ds2.nsub ds2.nrec]),
   error('Incomplete recording in dataset(s).');
end
if any([ds1.nsub ds2.nsub]~=2),
   error('Irregular number of conditions.');
end

% common part of cache identifier for sptcorr
CaCom = CollectInStruct(DFN, maxlag, binwidth);

% compute auto- and cross-correlograms. Note: rp1 is the subseq for which rho==1.
spt1 = AnWin(ds1.spt, burstdur1);
spt2 = AnWin(ds2.spt, burstdur2);
appliedNorm = '';
FixedArgs = {maxlag, binwidth, burstdur1, appliedNorm}; % abbr. for invariable arguments to sptcorr below
% common part of cache identifier for sptcorr
CaCom = CollectInStruct(DFN, maxlag, binwidth, burstdur1, appliedNorm);
% ds1: auto
[Auto1p,  BC, NormA1p]  = sptcorr(spt1(rp1,:), 'nodiag',    FixedArgs{:}, {CaCom dsid1 'p'});
[Auto1n,  BC, NormA1n]  = sptcorr(spt1(rm1,:), 'nodiag',    FixedArgs{:}, {CaCom dsid1 'n'});
[Auto1pn, BC, NormA1pn] = sptcorr(spt1(rp1,:), spt1(rm1,:), FixedArgs{:}, {CaCom dsid1 'pn'});
% ds2: auto
[Auto2p,  BC, NormA2p]  = sptcorr(spt2(rp2,:), 'nodiag',    FixedArgs{:}, {CaCom dsid2 'p'});
[Auto2n,  BC, NormA2n]  = sptcorr(spt2(rm2,:), 'nodiag',    FixedArgs{:}, {CaCom dsid2 'n'});
[Auto2pn, BC, NormA2pn] = sptcorr(spt2(rp2,:), spt2(rm2,:), FixedArgs{:}, {CaCom dsid2 'pn'});
% sd1-ds2: cross
[Crosspp, BC, NormCCpp] = sptcorr(spt1(rp1,:), spt2(rp2,:), FixedArgs{:}, {CaCom dsid1 dsid2 'pp'});
[Crossnn, BC, NormCCnn] = sptcorr(spt1(rm1,:), spt2(rm2,:), FixedArgs{:}, {CaCom dsid1 dsid2 'nn'});
[Crosspn, BC, NormCCpn] = sptcorr(spt1(rp1,:), spt2(rm2,:), FixedArgs{:}, {CaCom dsid1 dsid2 'pn'});
[Crossnp, BC, NormCCnp] = sptcorr(spt1(rm1,:), spt2(rp2,:), FixedArgs{:}, {CaCom dsid1 dsid2 'np'});
BC = BC(:); % column vector for easier ensemble plots

% compute "diffcors" to eliminate as well as possible DC components and rectification effects
% always convert to column vectors for easier ensemble plots
Auto1 = Auto1p(:)/NormA1p.DriesNorm + Auto1n(:)/NormA1n.DriesNorm - 2*Auto1pn(:)/NormA1pn.DriesNorm; 
Auto2 = Auto2p(:)/NormA2p.DriesNorm + Auto2n(:)/NormA2n.DriesNorm - 2*Auto2pn(:)/NormA2pn.DriesNorm; 
Cross = Crosspp(:)/NormCCpp.DriesNorm + Crossnn(:)/NormCCnn.DriesNorm ...
   - Crosspn(:)/NormCCpn.DriesNorm - Crossnp(:)/NormCCnp.DriesNorm;
N1 = max(Auto1); 
N2 = max(Auto2); 
NC = sqrt(N1*N2);
Auto1 = Auto1/N1;
Auto2 = Auto2/N2;
Cross = Cross/NC;
AllCorr = [Auto1, Auto2, Cross]; % plot(BC, AllCorr) will plot all 3 together

% Tau is the delay at max xcorr
Tau = maxloc(BC, Cross);
% maxcross is the maximum of the (normalized) crosscorrelation
MaxCross = max(Cross);
% now for the spectra
nbin = length(BC); 
hh = hanning(nbin); % window for fft
ZZZ = zeros(2^(2+nextpow2(nbin))-nbin, 1); % zeros to pad prior to fft
Tmax = (nbin+length(ZZZ))*binwidth; df = 1e3/Tmax; % spacing of freq components
SPA1 = a2db(abs(fft([hh.*Auto1; ZZZ])));
SPA2 = a2db(abs(fft([hh.*Auto2; ZZZ])));
SPCC = a2db(abs(fft([hh.*Cross; ZZZ])));
Freq = (0:length(SPA1)-1).'*df;
imax = max(find(Freq<=MaxFreq));
Freq = Freq(1:imax);  % restrict to low freqs
AllSpec = [SPA1, SPA2, SPCC]; % plot(BC, AllSpec) will plot all 3 together
AllSpec = AllSpec(1:imax,:); % restrict to low freqs
% spectral peaks
DomPers = maxloc(Freq, AllSpec);

%===================================
function [ds, burstdur, rp, rm] = localGetData(DFN, dsid);
% get spikes, stim parameters and check if right type
ds = dataset(DFN, dsid); 
if ~isequal('NRHO', upper(ds.stimtype)),
   error(['Not an NRHO dataset: "' DFN ', ' dsid '"']);
end
burstdur = min(ds.burstdur);
rp = find(ds.xval==1);
rm = find(ds.xval==-1);






