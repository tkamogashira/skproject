% V to dt1ms250msWaveSin16Hz32Hz245 245points
function MaxPhaseAmp16Hz32Hz=Vtodt1ms250msWaveSin16Hz32Hz245(V)
FFT=fft(V);
FFT(1)=[];
RFFT=[FFT(1:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.124800004:0.001:0.119200006];   
T1=[-0.03125:0.0001:0.03125];
T2=[-0.015625:0.0001:0.015625];
y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T1))/125;
y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T2)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T2))/125;
Y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/125;
Y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/125;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot(T,V,'k-',T,Y1,'r-',T,Y2,'g',T,(Y1+Y2),'k:'),grid;
axis([-0.125 0.125 -4 4]);
set(gca,'xtick',[-0.09375 -0.03125 0 0.03125 0.09375])
