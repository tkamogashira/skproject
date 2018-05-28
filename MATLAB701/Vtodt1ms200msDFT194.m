% V to dt1ms200msDFT194 194points
function DFT=Vtodt1ms200msDFT194(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
semilogx(FreqAxis,Amp),grid;
axis([1 50 0 4]);
DFT=[FreqAxis(1:40);Amp(1:40)]
