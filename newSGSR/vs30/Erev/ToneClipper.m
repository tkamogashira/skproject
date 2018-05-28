function [Levels, RR] = ToneClipper(maxLevel,N);
% ToneClipper - evaluate effect of clipping on relative ampltudes of tone complex

if nargin<2, 
   N = 10; % number of "background" tones
end

nn = 2^13;
phi = linspace(0,2*pi,nn+1); phi=phi(1:nn);
ntest = length(maxLevel);

freqs = round(100*rand(N,1));
F = round(100*rand(ntest,1));
while any(ismember(F,freqs)),
   F = round(100*rand(ntest,1));
end
rphase = 2*pi*rand(N,1)*ones(1,nn);


CC = sum(cos(freqs*phi+rphase),1);
toneLevels = [0 maxLevel(2:end)];
dsiz(freqs)
dsiz(F)
dsiz(phi)
dsiz(toneLevels)
Tone = db2a(toneLevels)*cos(F*phi);
maxLevel = maxLevel(1);
Levels = linspace(-maxLevel, maxLevel, 20);
RR = []; PP = [];
for level = Levels,
   stim = (CC + db2a(level)*Tone);
   sp = fft(sign(stim));
   RR = [RR; a2db(abs(sp(F+1)))];
   PP = [PP; angle(sp(F+1))];
end
dsiz(RR)
PP = unwrap(PP);
PP = (PP-PP(end))/2/pi;
RR = (RR-RR(end)) + maxLevel;
if nargout<1,
   xplot(Levels, RR);
   xplot(Levels, Levels,':');
   grid on
   figure(gcf+1);
   xplot(Levels, PP);
   figure(gcf-1);
end