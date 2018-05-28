% V to 16_600msDFT375modi 375points
function Vto16_600msDFT375modi(Vpre)
V=Vpre(126:500);
FFT=fft(V);
FFT(1)=[];
RFFT=[FFT(1:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.0016;
FreqAxis=(1:length(RFFT))/(length(FFT)/2)*nyquist;
semilogx(FreqAxis,Amp),grid;
axis([1 20 0 4]);
DFT=[FreqAxis(1:20);Amp(1:20)];
assignin('base',[inputname(1) '_fft666'],DFT);
end
