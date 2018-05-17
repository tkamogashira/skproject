function [iwave, ns] = coewav(c, ns)
%COEWAV Convert synthesis parameters to waveform

% Copyright (c) 2001 by Michael Kiefte.


impuls = c.impuls; % amplitude of glottal impulse
sinamp = c.sinamp; % amplitude of quasi-sinusoidal voicing
africi = c.africi; % amplitude of frication
aaspi = c.aaspi;   % amplitude of aspiration

% parallel resonator amplitudes
a1par = c.a1par;
a2par = c.a2par;
a3par = c.a3par;
a4par = c.a4par;
a5par = c.a5par;
a6par = c.a6par;
abpar = c.abpar; % amplitude of bypass parallel path
anpar = c.anpar; % amplitude of nasal parallel resonator

% glottal resonator
agp = c.agp;
bgp = c.bgp;
cgp = c.cgp;

% glottal zero
agz = c.agz;
bgz = c.bgz;
cgz = c.cgz;

% second glottal resonator
ags = c.ags;
bgs = c.bgs;
cgs = c.cgs;

% cascade resonator coefficients
a1 = c.a1;
b1 = c.b1;
c1 = c.c1;
a2 = c.a2;
b2 = c.b2;
c2 = c.c2;
a3 = c.a3;
b3 = c.b3;
c3 = c.c3;
a4 = c.a4;
b4 = c.b4;
c4 = c.c4;
a5 = c.a5;
b5 = c.b5;
c5 = c.c5;
a6 = c.a6;
b6 = c.b6;
c6 = c.c6;

% cascade nasal resonator
anp = c.anp;
bnp = c.bnp;
cnp = c.cnp;

% nasal zero
anz = c.anz;
bnz = c.bnz;
cnz = c.cnz;

plstep = c.plstep;      % amplitude of burst release
npulsn = fix(c.npulsn); % number of samples before next glottal pulse
nnxws = c.nnxws;        % number of samples per parameter update frame
nxsw = logical(c.nxsw); % cascade/parallel switch
nnxfc = c.nnxfc;        % number of cascade formants

sqrt43rds = sqrt(4/3);  % amplitude of noise generator
logp995 = log(.995);	% used for exponential decay of burst release
counter = (1:nnxws)';   % sample index within each update frame

% maximum value for a waveform sample (left-justify in 16-bit word)
wavmax = 32767;

% zero memory registers in all resonators
% parallel resonators F1-6 and nasal pole
yl1p = [0;0];
yl2p = [0;0];
yl3p = [0;0];
yl4p = [0;0];
yl5p = [0;0];
yl6p = [0;0];
ylnp = [0;0];

% cascade resonators F1-6
yl1c = [0;0];
yl2c = [0;0];
yl3c = [0;0];
yl4c = [0;0];
yl5c = [0;0];
yl6c = [0;0];

% nasal pole and zero
ylnpc = [0;0];
ylnzc = [0;0];

% glottal poles and zeros
ylgp = [0;0];
ylgs1 = [0;0];
ylgs2 = [0;0];
ylgz = [0;0];

% zero all other memory registers
npulse = 1; % glottal impulse counter
mpulse = 1; % voice modulation of frication counter
uglotx = 0; % last value of uglot for differentiation of glottal source
uglotl = 0; % voicing source differentiated in parallel branch
step = 0;   % last value of plosive release amplitude

% these values are used to linearly interpolate noise amplitudes
% within each frame
afric = 0;  % last value of frication amplitude
aaspir = 0; % last value of aspiration amplitude

iwave = zeros(nnxws*length(impuls), 1); % the resultant waveform

% put waveform in iwave
for i = 1:length(npulsn)

	% train if impulses for normal voicing---zero otherwise
	input = zeros(nnxws, 1); 

	% and for quasi-sinusoidal voicing
	inputs = input;

	% npulse is decremented by one at ever sample. Whenever npulse
	% reaches 0, a glottal pulse is emitted. If it has been
	% decreasing indefinitely because f0 has been set to 0 or av and
	% avs have been set to zero, then a glottal pulse is immediately
	% produced at the beginning of the update frame
	npulse = npulse(end) - counter;
	
	% mpulse is used for voice modulated noise
	mpulse = mpulse(end) - counter;

	if npulsn(i) > 1 % if f0 > 0 and av + avs > 0

		% emit impulse right away if start of voicing
		% set beginning to zero if negative
		if npulse(1) < 0
			npulse = npulse - npulse(1);
		end

		if ~all(npulse) % if pulse to be emitted this frame

			% don't do anything until impulse is emitted
			idx = min(find(~npulse));

			% set npulse to npulsn-1 following zeros
			npulse(idx:end) = mod(npulse(idx:end), npulsn(i));

			% set amplitude of impulse for normal voicing source
			input(~npulse) = impuls(i);

			% amplitude of quasi-sinusoidal voicing
			inputs(~npulse) = sinamp(i);

			% if we don't do this, we get in trouble if
			% the last value of npulse in the frame is zero
			npulse(~npulse) = npulsn(i);

			% so we can modulate frication in second half
			% of glottal period
			mpulse(idx:end) = npulse(idx:end) ...
				 - ceil(npulsn(i)/2);
		end
	end

	% First glottal resonator:
	[ygp ylgp] = filter(agp(i), [1 -bgp(i) -cgp(i)], input, ylgp);

	% Glottal zero:
	[ygz ylgz] = filter([agz(i) bgz(i) cgz(i)], 1, ygp, ylgz);

	% Quasi-sinusoidal voicing produced by impulse into both
	% glottal resonators:
	[ygs, ylgs1] = filter(ags(i), [1 -bgs(i) -cgs(i)], inputs, ylgs1);
	[ygs, ylgs2] = filter(agp(i), [1 -bgp(i) -cgp(i)], ygs, ylgs2);

	% Glottal volume velocity is the sum of normal and
	% quasi-sinusoidal voicing
	uglot2 = ygz + ygs;

    % Radiation characteristic:
	uglot = diff([uglotx; uglot2]);
	uglotx = uglot2(end);

	% Turbulence noise of aspiration and frication:
	% generate random noise
	% original code summed 16 random reals from a
	% uniform distribution (sigma^2 = 4/3) and
	% subtracted out mean
	if nargin == 2
		noise = ns((i-1)*nnxws+1:i*nnxws);
	else
		noise = sqrt43rds*randn(nnxws, 1);
	end

	% modulate noise during second half of a glottal period
	idx = mpulse <= 0;
	noise(idx) = noise(idx)/2;

	% low-pass noise at -6 dB/octave to simulate source impedence
	% high-pass noise at +6 dB/octave for radiation characteristic
	% (two effects cancel one another)
	
	% glottal source volume velocity = voicing + aspiration
	% amplitude of aspiration is interpolated linearly within each
	% update frame:
	aaspir = (aaspi(i) - aaspir(end))*counter/nnxws + aaspir(end);
	uglot = uglot + aaspir.*noise;

	% set frication source volume velocity
	afric = (africi(i) - afric(end))*counter/nnxws + afric(end);

	% prepare to add a step excitation of vocal tract
	% if plosive release (i.e. if plstep > 0)
	% plosive release is exponentially decayed indefinitely
	if plstep(i) > 0
		step = -plstep(i)*exp(counter*logp995 - logp995);
	else
		step = step(end)*exp(counter*logp995);
	end

	ufric = afric .* noise;

	% send glottal source thru cascade vocal tract resonators
	% do formant equations for nnxfc formants in descending order
	% to minimize transients

	if ~nxsw(i)

		% bypass F6 if nnxfc less than 6
		% zero out uglot if using parallel branch
		if nnxfc == 6
			[y6c yl6c] = filter(a6(i), [1 -b6(i) -c6(i)], ...
				uglot, yl6c);
		else
			y6c = uglot;
		end

		% bypass r5 if nnxfc less than 5
		if nnxfc >= 5
			[y5c yl5c] = filter(a5(i), [1 -b5(i) -c5(i)], ...
				y6c, yl5c);
		else
			y5c = y6c;
		end

		[y4c, yl4c] = filter(a4(i), [1 -b4(i) -c4(i)], y5c, yl4c);
		[y3c, yl3c] = filter(a3(i), [1 -b3(i) -c3(i)], y4c, yl3c);
		[y2c, yl2c] = filter(a2(i), [1 -b2(i) -c2(i)], y3c, yl2c);
		[y1c, yl1c] = filter(a1(i), [1 -b1(i) -c1(i)], y2c, yl1c);

		% nasal zero-pair:
		[yzc, ylnzc] = filter([anz(i) bnz(i) cnz(i)], 1, ...
			y1c, ylnzc);
		
		% nasal resonator:
		[ulipsv ylnpc] = filter(anp(i), [1 -bnp(i) -cnp(i)], ...
			yzc, ylnpc);
		
		% zero out voicing source if using cascade branch
		uglot = zeros(nnxws, 1);
		uglotl = 0;
	else
		ulipsv = zeros(nnxws, 1);
	end

	% first parallel formant r1' (excited by voicing only)
	[y1p yl1p] = filter(a1(i)*a1par(i), [1 -b1(i) -c1(i)], ...
		uglot, yl1p);
	
	% nasal pole rn' (excited by first diff. of voicing source)
	uglot1 = diff([uglotl; uglot]);
	uglotl = uglot(end);
	[yn ylnp] = filter(anp(i)*anpar(i), [1 -bnp(i) -cnp(i)], ...
		uglot1, ylnp);
	
	% excite formants r2'-r4' with fric noise plus first-diff voicing
	[y2p yl2p] = filter(a2(i)*a2par(i), [1 -b2(i) -c2(i)], ...
		ufric + uglot1, yl2p);
	[y3p yl3p] = filter(a3(i)*a3par(i), [1 -b3(i) -c3(i)], ...
		ufric + uglot1, yl3p);
	[y4p yl4p] = filter(a4(i)*a4par(i), [1 -b4(i) -c4(i)], ...
		ufric + uglot1, yl4p);
	
	% excite formant resonators r5'-r6' with fric noise
	[y5p yl5p] = filter(a5(i)*a5par(i), [1 -b5(i) -c5(i)], ...
		ufric, yl5p);
	[y6p yl6p] = filter(a6(i)*a6par(i), [1 -b6(i) -c6(i)], ...
		ufric, yl6p);

	% add up outputs from rn' r1' - r6' and bypass path
	ulipsf = y1p - y2p + y3p - y4p + y5p - y6p + yn - abpar(i)*ufric;

	% add cascade and parallel vocal tract outputs
	% (scale by 170 to left justify in 16-bit word
	ulips = (ulipsv + ulipsf + step)*170;

	% truncate waveform samples to abs(wavmax)
%	ulips = max(min(ulips, wavmax), -wavmax);

	% add cascade and parallel vocal tract outputs
	iwave((i-1)*nnxws+1:i*nnxws) = ulips;
    if nargout >= 2
        ns((i-1)*nnxws+1:i*nnxws) = noise;
    end
end

% assume waveform will be saved as 16-bits
%iwave = iwave/32768;
