function bn = beatnoise(Fmin, Ncomp, DFmin, DF0, Rseed);
% BeatNoise - noise consisting of unevenly spaced tones
%   bn = beatnoise(Fmin, Ncomp, Nbase, DF0, Rseed);
if nargin<5, Rseed = SetRandState; end;
NC4 = Ncomp + 3-rem(Ncomp-1,4); % round towards next 4-fold
ndiff = reshape(1:NC4,4,NC4/4);
ndiff = ndiff([3 4 1 2],:);
Nbase = round(DFmin/DF0)
ndiff = Nbase+ndiff(1:Ncomp-1);
Nmin = round(Fmin/DF0);
freq = Nmin + cumsum([0 ndiff]); % freq spacings in DF0 units
[Fsam, iFilt] = safesamplefreq(max(freq)*DF0)
freq*DF0
Nsam = round(Fsam/DF0); % # samples of one cycle
Nsam = lowFacApprox(Nsam,13); % round for faster FFTs
% build spectrum
spec = zeros(1,Nsam);
spec(freq) = exp(2*pi*i*rand(1,Ncomp)); % eq amp, random  phase
% plot(abs(spec))
bn = spec;
