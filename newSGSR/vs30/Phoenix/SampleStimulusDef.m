% sample stimulus definition - test stimulus stuff

Fsam = 100e3; % Hz
durs = [10 5 7.9]; % ms
freqs = 0*durs+[500 200 1111]; % Hz
N = length(durs);
ST = stimulus('PIPS', mfilename)

for ii=1:N,
   Nsam = round(Fsam*1e-3*durs(ii));
   omega = 2*pi*freqs(ii)/Fsam; % freq in rad/sample
   sam = sin((0:Nsam-1)*omega);
   ST = addChunk(ST, sam);
end

[ST, iw1] = defineWaveform(ST, [3 2 1 1], [1 3 1 1], 'L', 1, Fsam);
[ST, iw2] = defineWaveform(ST, [3 2 1], [1 3 2], 'R', 1, Fsam);


[ST, is1] = defineDAshot(ST, [iw1 iw2], [20 25]);

[ST, is2] = defineDAshot(ST, [iw1 iw2; iw1 iw2], [20 25], [], [1 1; 0.1 10]);





