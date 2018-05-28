% V to dt1ms250msDFT245 245points
function DFT=Vtodt1ms250msDFT245(V)
FFT=fft(V);
FFT(1)=[];
RFFT=[FFT(1:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
semilogx(FreqAxis,Amp),grid;
axis([1 40 0 4]);
DFT=[FreqAxis(1:20);Amp(1:20)]
