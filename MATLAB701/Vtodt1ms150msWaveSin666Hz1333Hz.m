% V to dt1ms150msWaveSin666Hz1333Hz
function MaxPhaseAmp666Hz1333Hz=Vtodt1ms150msWaveSin666Hz1333Hz(V)
FFT=fft(V(51:200));
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.075:0.001:0.074];
T1=[-0.075:0.0001:0.075];
T2=[-0.0375:0.0001:0.0375];
y1=(real(RFFT(1))*cos(2*pi*FreqAxis(1)*T1)-imag(RFFT(1))*sin(2*pi*FreqAxis(1)*T1))/75;
y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T2)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T2))/75;
Y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T1)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T1))/75;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot(T,V(51:200),'k-',T1,y1,'r-',T1,Y2,'g',T1,(y1+Y2),'k:'),grid;
axis([-0.075 0.075 -4 4]);
set(gca,'xtick',[-0.075 -0.0375 0 0.0375 0.075])
