% EREV analyze script

binw = 0.2;
if ~exist('AMP'),
   XC = 0; for ii=1:5, XC = XC + erevanalyze('A0107',[49:54],ii,binw)/5; end; aa;
   NN = length(XC);
   AMP = (fftshift(a2db(abs(fft(hanning(NN).'.*(XC))))));
   PHA = (unwrap(fftshift(angle(fft(hanning(NN).'.*(XC))))));
end

fff = (linspace(0,60e3,NN) - 30e3 + 10e3)/1e3;
iii = find((fff>7)&(fff<13));

figure
subplot(2,1,1);
plot(fff(iii), AMP(iii));
axis([7 13 0 40]);
ylabel('Gain (dB)')
title(['CF ~ 10.7 kHz   binw = ' num2str(binw)  ' ms']);

subplot(2,1,2);
pha = PHA(iii); pha = pha-max(pha);
plot(fff(iii), pha/2/pi); %axis([8 12 min(PHA) max(PHA)]);
xlabel('freq (kHz)')
ylabel('Phase (cycles)')

% thr
figure;
DD = GetSGSRdata('A0107',55);
plot(DD.thrCurve.freq/1e3,DD.thrCurve.threshold);
xlabel('freq (kHz)');
ylabel('threshold (dB SPL)');
