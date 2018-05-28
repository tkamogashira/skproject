% V to dt1ms150msMaxPhaseAmp666Hz1333Hz
function MaxPhaseAmp666Hz1333Hz=Vtodt1ms150msMaxPhaseAmp666Hz1333Hz(V)
FFT=fft(V(51:200));
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T1=[-0.075:0.0001:0.075];
T2=[-0.0375:0.0001:0.0375];
y1=(real(RFFT(1))*cos(2*pi*FreqAxis(1)*T1)-imag(RFFT(1))*sin(2*pi*FreqAxis(1)*T1))/75;
y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T2)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T2))/75;
Y2=(real(RFFT(2))*cos(2*pi*FreqAxis(2)*T1)-imag(RFFT(2))*sin(2*pi*FreqAxis(2)*T1))/75;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot((T1(MaxPhaseI1))/0.075,Amp(1),'ro',(T2(MaxPhaseI2))/0.0375,Amp(2),'go'),grid;
axis([-1 1 0 4]);
set(gca,'xtick',[-1 0 1]);
MaxPhaseAmp666Hz1333Hz=[T1(MaxPhaseI1) T2(MaxPhaseI2);Amp(1) Amp(2)]

