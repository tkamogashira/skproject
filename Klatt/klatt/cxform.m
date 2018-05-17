function [iwave, fs, ns] = cxform(h, A, a, k, F, fs, ns)
%CXFORM Cochlear normalized wavelet speech synthesizer
%  [X FS] = CXFORM(H, A, a, K, F) returns a cochlear normalized speech sample
%  based on the struct H as returned by the program HANDSY. A, a, K, and F are
%  frequency-place parameters as described by COCHN.
%
%  CXFORM(H, A, a, K, F, FS) gives the sampling rate. By default the program
%  chooses a sensible rate based on the cochlear frequency-position of the
%  original Nyquist frequency (which is 10 kHz by default in HANDSY).
%
%  CXFORM(H, SPECIES) where SPECIES is the name of a particular animal will use
%  constants as returned by the function GRNWDSPC.

%  Copyright (c) 2001 by Michael Kiefte.

if nargin < 6
    fs = [];
end

if ischar(A)
    if nargin >= 5
        ns = F;
    end
    if nargin >= 4
        fs = k;
    end
    if nargin >= 3
        F = a;
    end
    [A a k] = grnwdspc(A);
end

%find new sampling rate based on normalized cochlear distance
%of original Nyquist frequency
if nargin < 6
	fsnew = h.sr*ceil(2*cochn(h.sr/2, A, a, k, F)/h.sr);
	if isempty(fs) & fsnew ~= 10000
		warning(sprintf('Sampling rate set to %d Hz.', fsnew));
	end
    fs = fsnew;
end

% update frame length in H.NWS
h.nws = h.nws*fs/h.sr;
h.sr = fs;
c = parcoef(parmcont(h));

nframes = length(c.impuls);
implen = 2^nextpow2(fs*.02);        % number of samples in warped spectrum
nrfft = implen/2+1;                 % positive frequencies only
zi = zeros(implen-1, 3);            % filter memory
                                    % first column is for voicing source
                                    % second column is for aspiration
                                    % third is for frication
iwave = zeros(h.nws*nframes, 1);

% determine normalized frequencies for human listener
% based on non-human target range 0-fs/2
f = invcochn(linspace(0, fs/2, nrfft)', A, a, k, F);

npulse = 1; % glottal pulse counter
mpulse = 1; % half-period counter
aaspir = 0; % aspiration coutner
afric  = 0; % frication counter
step   = 0; % burst impulse

counter = (1:h.nws)';

for i = 1:nframes
    input = zeros(h.nws, 1);
    npulse = npulse(end) - counter;
    mpulse = mpulse(end) - counter;
  
    if c.npulsn(i) > 1 % if voiced
        
        if npulse(1) < 0                 % back on after unvoiced period
            npulse = npulse - npulse(1); % reset it
        end

        if ~all(npulse)       % glottal pulse in frame
            idx = min(find(~npulse));
            
            % every time there is a glottal pulse counter has to be reset
            npulse(idx:end) = mod(npulse(idx:end), c.npulsn(i));
            input(~npulse) = 1;
            npulse(~npulse) = c.npulsn(i); % just in case glottal pulse
                                           % is the last sample in the frame
            mpulse(idx:end) = npulse(idx:end) - ceil(c.npulsn(i)/2);
        end
    end
  
    ygp = c.impuls(i) * freqz(c.agp(i), [1 -c.bgp(i) -c.cgp(i)], f, fs);
    ygz = ygp.*freqz([c.agz(i) c.bgz(i) c.cgz(i)], 1, f, fs);
   
    % sinusoidal voicing
    ygs = c.sinamp(i) * freqz(c.ags(i), [1 -c.bgs(i) -c.cgs(i)], f, fs) ...
        .* freqz(c.agp(i), [1 -c.bgp(i) -c.cgp(i)], f, fs);
    
    % fortunately, this is distributive in the frequency domain as well
    % so we can add these together
    uglot2 = ygz + ygs;
    
    % first difference
    uglot = uglot2 .* freqz([1 -1], 1, f, fs);
  
    if nargin < 7
        noise = sqrt(4/3)*randn(h.nws, 1);          % there's always noise
        noise(mpulse <= 0) = noise(mpulse <= 0)/2;  % but in the second half of the
                                                    % period it's 6 dB quieter
    else
        noise = reshape(ns((i-1)*h.nws+1:i*h.nws), h.nws, 1);
    end

    % aspiration
    aaspir = (c.aaspi(i) - aaspir(end))*counter/h.nws + aaspir(end);
    
    % frication
    afric = (c.africi(i) - c.africi(end))*counter/h.nws + afric(end);
    
    % plosive release
    if c.plstep(i) > 0
        step = -c.plstep(i)*exp(counter*log(0.995) - log(0.995));
    else
        step = step(end)*exp(counter*log(0.995));
    end
    
    if ~c.nxsw(i)

        % now we have to make a second column for the noise source passing through
        % the cascade branch
        if h.nfc == 6
            y6c = sparse(1:nrfft, 1:nrfft, ...
                freqz(c.a6(i), [1 -c.b6(i) -c.c6(i)], f, fs)) ...
                * [uglot ones(nrfft, 1)];
        else
            y6c = [uglot ones(nrfft, 1)];
        end
        
        if h.nfc >= 5
            y5c = sparse(1:nrfft, 1:nrfft, ...
                freqz(c.a5(i), [1 -c.b5(i) -c.c5(i)], f, fs)) * y6c;
        else
            y5c = y6c;
        end
        y4c = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.a4(i), [1 -c.b4(i) -c.c4(i)], f, fs)) * y5c;
        y3c = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.a3(i), [1 -c.b3(i) -c.c3(i)], f, fs)) * y4c;
        y2c = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.a2(i), [1 -c.b2(i) -c.c2(i)], f, fs)) * y3c;
        y1c = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.a1(i), [1 -c.b1(i) -c.c1(i)], f, fs)) * y2c;
        yzc = sparse(1:nrfft, 1:nrfft, ...
            freqz([c.anz(i) c.bnz(i) c.cnz(i)], 1, f, fs)) * y1c;

        % third column is frication
        ulipsv = [sparse(1:nrfft, 1:nrfft, ...
            freqz(c.anp(i), [1 -c.bnp(i) -c.cnp(i)], f, fs)) * yzc ...
            zeros(nrfft, 1)];
    else
        ulipsv = zeros(nrfft, 3); % zero out cascade contribution
    end
    
    % first parallel formant excited by voicing and aspiration only
    y1p = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.a1(i)*c.a1par(i), [1 -c.b1(i) -c.c1(i)], f, fs)) ...
            * [uglot ones(nrfft, 1)];
        
    % formants 2-4 excited by first difference of voicing and aspiration
    uglot1 = sparse(1:nrfft, 1:nrfft, ...
        freqz([1 -1], 1, f, fs)) * [uglot ones(nrfft, 1)];
    % nasal pole too
    yn = sparse(1:nrfft, 1:nrfft, ...
            freqz(c.anp(i)*c.anpar(i), [1 -c.bnp(i) -c.cnp(i)], f, fs)) ...
            * uglot1;
    y2p = sparse(1:nrfft, 1:nrfft, ...
        freqz(c.a2(i)*c.a2par(i), [1 -c.b2(i) -c.c2(i)], f, fs)) ...
        * uglot1;
    y3p = sparse(1:nrfft, 1:nrfft, ...
        freqz(c.a3(i)*c.a3par(i), [1 -c.b3(i) -c.c3(i)], f, fs)) ...
        * uglot1;
    y4p = sparse(1:nrfft, 1:nrfft, ...
        freqz(c.a4(i)*c.a4par(i), [1 -c.b4(i) -c.c4(i)], f, fs)) ...
        * uglot1;
        
    % formants 5-6 excited by frication only
    y5p = freqz(c.a5(i)*c.a5par(i), [1 -c.b5(i) -c.c5(i)], f, fs);
    y6p = freqz(c.a6(i)*c.a6par(i), [1 -c.b6(i) -c.c6(i)], f, fs);
    
    ulipsf = [y1p - y2p + y3p - y4p + yn, ... % first two columns
            y5p - y6p - c.abpar(i)];          % frication column
    
    ulips = 170*(ulipsv + ulipsf);
    
    four = [ulips; conj(ulips(implen/2:-1:2, :))];
    cfac = real(ifft(four));
    source = [input noise.*aaspir noise.*afric];
    for j = size(cfac, 2):-1:1
        [x(:,j) zi(:,j)] = filter(cfac(:,j), 1, source(:,j), zi(:,j));
    end
    
    % sum together sources
    iwave((i-1)*h.nws+1:i*h.nws) = step + sum(x, 2);
    
    if nargout >= 3
        ns((i-1)*h.nws+1:i*h.nws) = noise;
    end
end