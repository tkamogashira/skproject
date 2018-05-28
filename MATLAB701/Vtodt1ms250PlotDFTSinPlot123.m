% V to dt1ms250PlotDFTSinPlot123
function Vtodt1ms250PlotDFTSinPlot123(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2)) FFT(((length(FFT)/2)+2):length(FFT))];
Amp=abs(RFFT(1:length(RFFT)/2))/(length(FFT)/2);
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
SinPhase=CosPhase+0.5;
T=[-0.126000002:0.001:0.123000011];
y1=Amp(1)*sin(2*pi*FreqAxis(1)*T+SinPhase(1)*pi);
y2=Amp(2)*sin(2*pi*FreqAxis(2)*T+SinPhase(2)*pi);
y3=Amp(3)*sin(2*pi*FreqAxis(3)*T+SinPhase(3)*pi);
y123=y1+y2+y3;
plot(T,V,'k-',T,y1,'r-',T,y2,'y-',T,y3,'g-',T,y123,'k:'),grid;
axis([-0.125 0.125 -4 4])
