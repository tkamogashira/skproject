% V to dt1ms250msWaveSin4Hz8Hz
function MaxPhaseAmp4Hz8Hz=Vtodt1ms250msWaveSin4Hz8Hz(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.125:0.001:0.124];
T1=[-0.125:0.0001:0.125];
T2=[-0.0625:0.0001:0.0625];
y1=(real(RFFT(1))*cos(2*pi*FreqAxis(1)*T1)-imag(RFFT(1))*sin(2*pi*FreqAxis(1)*T1))/125;
y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T2)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T2))/125;
Y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T1)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T1))/125;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot(T,V,'k-',T1,y1,'r-',T1,Y2,'g',T1,(y1+Y2),'k:'),grid;
axis([-0.125 0.125 -4 4]);
set(gca,'xtick',[-0.125 -0.0625 0 0.0625 0.125])
