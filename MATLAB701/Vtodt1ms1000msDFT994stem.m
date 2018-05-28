% V to dt1ms1000msDFT994stem 994points
function DFT=Vtodt1ms1000msDFT994stem(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
stem(FreqAxis,Amp),grid;
axis([1 20 0 4]);
DFT=[FreqAxis(1:20);Amp(1:20)]
