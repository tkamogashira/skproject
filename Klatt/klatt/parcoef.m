function c = parcoef(s)
% PARCOEF Convert stimulus parameters into synthesis parameters
%   C = PARCOEF(S), where S is a structure produced by the interactive
%   program HANDSY, produces a structure suitable for COEWAV which, in
%   turn, produces a waveform corresponding to the stimulus parameters in
%   S.
%   The fields returned by the function are the following:
%   
%   These fields hold amplitude values having been converted from dB:
%   IMPULS: amplitude of voicing source
%   SINAMP: amplitude of quasi-sinusoidal voicing source
%   AFF: amplitude of frication source
%   AHH: amplitude of aspiration source
%   A1P, A2P, A3P, A4P, A5P, A6P: amplitudes of parallel formants a1 thru a6
%   ABP: amplitude of bypass path of frication tract
%   ANPP: amplitude of parallel nasal formant
%   PLSTEP: plosive amplitude
%   
%   Numerator coefficients for resonators are defined as b = [A, -B, -C]:
%   AGP, BGP, CGP: first glottal resonator coefficients
%   AGS, BGS, CGS: second glottal resonator coefficients
%   A1, B1, C1 thru A6, B6, C6: formant resonator coefficients
%   ANP, BNP, CNP: nasal resonator coefficients
%   
%   Denominator coefficients of zeros are defined as a = [1, B, C]. The
%   numerator is simply b = A:
%   AGZ, BGZ, CGZ: glottal zero coefficients
%   ANZ, BNZ, CNZ: nasal zero coefficients
%   
%   Additional fields:
%   NPULSN: number of samples between glottal pulses
%   NNXWS: number of waveform samples per update frame
%   NXSW: cascade/parallel switch
%   NXNFC: number of cascade formants

%   Copyright (c) 2000 by Michael Kiefte.

% names of input control parameters
nnav = s.av;
nnaf = s.af;
nnah = s.ah;
nnavs = s.avs;
nnf0 = s.f0;
nnf1 = s.f1;
nnf2 = s.f2;
nnf3 = s.f3;
nnf4 = s.f4;
nnfnz = s.fnz;
nnan = s.an;
nna1 = s.a1;
nna2 = s.a2;
nna3 = s.a3;
nna4 = s.a4;
nna5 = s.a5;
nna6 = s.a6;
nnab = s.ab;
nnb1 = s.b1;
nnb2 = s.b2;
nnb3 = s.b3;
nnsw = logical(s.sw);
nnfgp = s.fgp;
nnbgp = s.bgp;
nnfgz = s.fgz;
nnbgz = s.bgz;
nnb4 = s.b4;
nnf5 = s.f5;
nnb5 = s.b5;
nnf6 = s.f6;
nnb6 = s.b6;
nnfnp = s.fnp;
nnbnp = s.bnp;
nnbnz = s.bnz;
nnbgs = s.bgs;
nnsr = s.sr;
nnnws = s.nws;
nng0 = s.g0;
nnnfc = s.nfc;

% scale factors in dB for general adjustment to:
%          a1  a2  a3  a4  a5  a6  an  ab  av   ah  af avs
ndbsca = [-58 -65 -73 -78 -79 -80 -58 -84 -72 -102 -72 -44];

% compute sampling period t
t = 1/nnsr;
pit = pi*t;

% update all coefficients of hardware synthesizer

% compute parallel branch amplitude correction to f2 due to f1
cor = (nnf1/500).^2;

% compute amplitude correction to f3-5 due to f1 and f2
delf2 = nnf2/1500;
a3cor = cor .* delf2.^2;

% take into account first diff of glottal wave for f2
a2cor = cor./delf2;

% compute amplitude corrections due to proximity of 2 formants
% increment formant amplitudes of parallel branch if
% formant frequency difference 50, 100, 150, ... Hz
% 1 dB for every 50 Hz.
% if formants are too close, don't do correction
nf21 = nnf2 - nnf1;
n12cor = max(0, 11 - fix(nf21/50));
n12cor(nf21 < 50) = 0;

nf32 = nnf3 - nnf2 - 50;
n23cor = max(0, 11 - fix(nf32/50));
n23cor(nf32 < 50) = 0;

nf43 = nnf4 - nnf3 - 150;
n34cor = max(0, 11 - fix(nf43/50));
n34cor(nf43 < 40) = 0;

% set amplitude of voicing
impuls = getamp(nng0 + nnav + ndbsca(9));

% amplitude of aspiration
ahh = getamp(nng0 + nnah + ndbsca(10));

% amplitude of frication
% (in an all parallel configuration, af=max(af,ah))
nnaf(nnsw) = max(nnaf(nnsw), nnah(nnsw));
aff = getamp(nng0 + nnaf + ndbsca(11));

% add a step to waveform at a plosive release
plstep = zeros(size(nnaf));
idx = find(diff([0; nnaf]) >= 49);
plstep(idx) = getamp(nng0 + ndbsca(11) + 44);

% amplitude of quasi-sinusoidal voicing source
sinamp = 10*getamp(nng0 + nnavs + ndbsca(12));

% set amplitudes of parallel formants a1 thru a6
a1p = getamp(nna1 + n12cor + ndbsca(1));
a2p = a2cor.*getamp(nna2 + 2*n12cor + n23cor + ndbsca(2));
a3p = a3cor.*getamp(nna3 + 2*n23cor + n34cor + ndbsca(3));
a4p = a3cor.*getamp(nna4 + 2*n34cor + ndbsca(4));
a5p = a3cor.*getamp(nna5 + ndbsca(5));
a6p = a3cor.*getamp(nna6 + ndbsca(6));

% set amplitude of parallel nasal formant
anpp = getamp(nnan + ndbsca(7));

% set amplitude of bypass path of frication tract
abp = getamp(nnab + ndbsca(8));

% reset difference equation constants for resonators
[a1 b1 c1] = setabc(nnf1, nnb1, pit);
[a2 b2 c2] = setabc(nnf2, nnb2, pit);
[a3 b3 c3] = setabc(nnf3, nnb3, pit);
[a4 b4 c4] = setabc(nnf4, nnb4, pit);
[a5 b5 c5] = setabc(nnf5, nnb5, pit);
[a6 b6 c6] = setabc(nnf6, nnb6, pit);
[anp bnp cnp] = setabc(nnfnp, nnbnp, pit);

% and for nasal resonator
mnfnz = min(-1, -nnfnz);
[anz bnz cnz] = setabc(mnfnz, nnbnz, pit);

npulsn = ones(size(nnav));
agp = zeros(size(nnav));
bgp = agp;
cgp = agp;
ags = agp;
bgs = agp;
cgs = agp;
agz = agp;
bgz = agp;
cgz = agp;

% and for glottal resonators and antiresonator
% issue no pulse if nnav and nnavs are both zero or if f0 is zero
idx = find(nnf0 > 0 & (nnav > 0 | nnavs > 0));
if ~isempty(idx) 

	% waveform more sinusoidal at high fundamental frequencies
	nxbgp = fix(100*nnbgp(idx)./nnf0(idx));
	[temp bgp(idx) cgp(idx)] = setabc(nnfgp(idx), nxbgp, pit);
	[ags(idx) bgs(idx) cgs(idx)] = setabc(0, nnbgs, pit);
	mnfgz = min(-1, -nnfgz(idx));
	[agz(idx) bgz(idx) cgz(idx)] = setabc(mnfgz, nnbgz(idx), pit);

	% set gain to constant in mid-frequency region for rgp
	agp(idx(1):end) = .007;

	% do not let drop below 40 Hz
	f0 = max(40, nnf0(idx));

	% make amplitude of impulse increase with increasing f0
	impuls(idx) = impuls(idx).*f0;

	% number of samples before a new glottal pulse may be generated
	npulsn(idx) = fix(nnsr./f0);
end

% fill in values so that sudden silence doesn't create discontinuities
bgp = lastval(bgp);
cgp = lastval(cgp);
ags = lastval(ags);
bgs = lastval(bgs);
cgs = lastval(cgs);
agz = lastval(agz);
bgz = lastval(bgz);
cgz = lastval(cgz);

c = struct('impuls', impuls, ...
	'sinamp', sinamp, ...
	'africi', aff, ...
	'aaspi', ahh, ...
	'a1par', a1p, ...
	'a2par', a2p, ...
	'a3par', a3p, ...
	'a4par', a4p, ...
	'a5par', a5p, ...
	'a6par', a6p, ...
	'abpar', abp, ...
	'anpar', anpp, ...
	'agp', agp, ...
	'bgp', bgp, ...
	'cgp', cgp, ...
	'agz', agz, ...
	'bgz', bgz, ...
	'cgz', cgz, ...
	'ags', ags, ...
	'bgs', bgs, ...
	'cgs', cgs, ...
	'a1', a1, ...
	'b1', b1, ...
	'c1', c1, ...
	'a2', a2, ...
	'b2', b2, ...
	'c2', c2, ...
	'a3', a3, ...
	'b3', b3, ...
	'c3', c3, ...
	'a4', a4, ...
	'b4', b4, ...
	'c4', c4, ...
	'a5', a5, ...
	'b5', b5, ...
	'c5', c5, ...
	'a6', a6, ...
	'b6', b6, ...
	'c6', c6, ...
	'anp', anp, ...
	'bnp', bnp, ...
	'cnp', cnp, ...
	'anz', anz, ...
	'bnz', bnz, ...
	'cnz', cnz, ...
	'plstep', plstep, ...
	'npulsn', npulsn, ...
	'nnxws', nnnws, ...
	'nxsw', nnsw, ...
	'nnxfc', nnnfc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = lastval(a)
% fill in zeros with last nonzero value
% assume a is column vector

x = a;

%index of last nonzero value (before zeros)
last = find(a & ~[a(2:end); 0]);

% no nonzero values
if isempty(last) return, end

% index of first nonzero value (after zeros)
first = find(a & ~[0; a(1:end-1)]);

% generate vector only with nonzero values which were originally
% followed by zeros. Negate those values at the first nonzero following
% this. The cumulative sum will then contain only the last nonzero
% values followed by zeros at those originally zero values.
cs = zeros(size(a));
cs(last) = a(last);
cs(first(2:end)) = -a(last(1:end-1));
cs = cumsum(cs);
x(~a) = cs(~a);
