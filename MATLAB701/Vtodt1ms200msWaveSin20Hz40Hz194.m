% V to dt1ms200msWaveSin20Hz40Hz194 194points
function MaxPhaseAmp20Hz40Hz=Vtodt1ms200msWaveSin20Hz40Hz194(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.098900005:0.001:0.094100006];     
T1=[-0.025:0.0001:0.025];
T2=[-0.0125:0.0001:0.0125];
y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T1))/100;
y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T2)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T2))/100;
Y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/100;
Y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/100;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot(T,V,'k-',T,Y1,'r-',T,Y2,'g',T,(Y1+Y2),'k:'),grid;
axis([-0.100 0.100 -4 4]);
set(gca,'xtick',[-0.075 -0.025 0 0.025 0.075])
