% V to dt1ms500msMaxPhaseAmp8Hz16Hz494 494points
function MaxPhaseAmp8Hz16Hz=Vtodt1ms500msMaxPhaseAmp8Hz16Hz494(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.248899996:0.001:0.244100034];  
T1=[-0.0625:0.0001:0.0625];
T2=[-0.03125:0.0001:0.03125];
y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T1))/250;
y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T2)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T2))/250;
Y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/250;
Y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/250;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot((T1(MaxPhaseI1))/0.0625,Max1,'ro',(T2(MaxPhaseI2))/0.03125,Max2,'go'),grid;
axis([-1 1 0 4]);
set(gca,'xtick',[-1 0 1]);
MaxPhaseAmp8Hz16Hz=[T1(MaxPhaseI1) T2(MaxPhaseI2);Max1 Max2]

