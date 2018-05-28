N = 2e4; Freq = 1e-3; Amp = 0; DC = -0.5; F2 = 2; 
y=langevin(0, N, [1 0 -F2 0 1], 15, 3, [DC 0 Freq]); 
f1; plot(y); 
y2=langevin(0, N, [1 0 -F2 0 1], 15, 3, [DC Amp Freq]); 
f1; xplot(y2, 'r'); 
dprime = mean(y2-y)/std(y)

% Langevin2
N = 2e4; Freq = 1e-3; Amp = 3; DC = -3; B = 15; w = 0.4;
gamma=13; T = 8; 
y=langevin2(0, N, [B w], gamma, T, [DC 0 Freq]); 
f1; plot(y); 
y2=langevin2(0, N, [B w], gamma, T, [DC Amp Freq]); f1; xplot(y2, 'r'); 
dprime = mean(y2-y)/std(y)

B = 0;
Freq = [1e-4 3e-4 1e-3 3e-3 1e-2 3e-2 1e-1 3e-1 ];
dprime = [];
for freq = Freq,
   freq
   y=langevin2(0, N, [B w], gamma, T, [DC 0 freq]); 
   y2=langevin2(0, N, [B w], gamma, T, [DC Amp freq]);
   dprime = [dprime mean(y2-y)/std(y)];
end

f5; semilogx(Freq, dprime);







