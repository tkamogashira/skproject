% V to dt1ms100PlotDFTSinPlot10Hz124816
function Vtodt1ms100PlotDFTSinPlot10Hz124816(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT(1:length(RFFT)/2))/(length(FFT)/2);
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.049900003:0.001:0.044100001];
y1=(real(RFFT(1))*cos(2*pi*FreqAxis(1)*T)-imag(RFFT(1))*sin(2*pi*FreqAxis(1)*T))/50;
y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T))/50;
y4=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/50;
y8=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/50;
y16=(real(RFFT(16))*cos(2*pi*FreqAxis(16)*T)-imag(RFFT(16))*sin(2*pi*FreqAxis(16)*T))/50;
y124816=y1+y2+y4+y8+y16;
plot(T,V,'k-',T,y1,'r-',T,y2,'y-',T,y4,'g-',T,y8,'c-',T,y16,'b-',T,y124816,'k:'),grid;
axis([-0.050 0.050 -4 4])
