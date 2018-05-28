% EREV analyze script

binw = 0.2;
if ~exist('AMP'),
   TRF = 0; 
   for ii=1:5, 
      [TRFi, freq, sel] = erevanalyze2('A0107',[49:54],ii,binw); 
      TRF = TRF + TRFi(sel)/5; 
   end; 
   freq = freq(sel)/1e3; % Hz->kHz
   AMP = a2db(abs(TRF));
   PHA = unwrap(angle(TRF))/2/pi; % in cycles
end
figure;
subplot(2,1,1);
h1 = plot(freq,AMP);
ylabel('Gain (dB)')
title(['CF ~ 10.7 kHz   binw = ' num2str(binw)  ' ms']);
set(gca, 'Ylim', [0 40]);
subplot(2,1,2);
plot(freq,PHA);
xlabel('freq (kHz)');
ylabel('Phase (cycles)')

return


fff = (linspace(0,60e3,NN) - 30e3 + 10e3)/1e3;
iii = find((fff>7)&(fff<13));

figure
subplot(2,1,1);
plot(fff(iii), AMP(iii));
axis([7 13 0 40]);

subplot(2,1,2);
pha = PHA(iii); pha = pha-max(pha);
plot(fff(iii), pha/2/pi); %axis([8 12 min(PHA) max(PHA)]);
xlabel('freq (kHz)')

% thr
figure;
DD = GetSGSRdata('A0107',55);
plot(DD.thrCurve.freq/1e3,DD.thrCurve.threshold);
