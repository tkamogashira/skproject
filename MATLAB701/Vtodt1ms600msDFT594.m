% V to dt1ms600msDFT594 594points
function DFT=Vtodt1ms600msDFT594(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
semilogx(FreqAxis,Amp),grid;
axis([1 20 0 4]);
DFT=[FreqAxis(1:20);Amp(1:20)]
