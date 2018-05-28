% V to dt1ms250PlotDFTSinPlot4Hz1248
function Vtodt1ms250PlotDFTSinPlot4Hz1248(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.126000002:0.001:0.123000011];
y1=(real(RFFT(1))*cos(2*pi*FreqAxis(1)*T)-imag(RFFT(1))*sin(2*pi*FreqAxis(1)*T))/125;
y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T))/125;
y4=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/125;
y8=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/125;
y1248=y1+y2+y4+y8;
plot(T,V,'k-',T,y1,'r-',T,y2,'y-',T,y4,'g-',T,y8,'c-',T,y1248,'k:'),grid;
axis([-0.125 0.125 -4 4])