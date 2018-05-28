% V to dt1ms1000msMaxPhaseAmp4Hz8Hz999 999points
function MaxPhaseAmp4Hz8Hz=Vtodt1ms250msMaxPhaseAmp4Hz8Hz999(V)
FFT=fft(V);
FFT(1)=[];
RFFT=[FFT(1:(length(FFT)/2))];
Amp=abs(RFFT/(length(FFT)/2));
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
T=[-0.500900030:0.001:0.497100025];
T1=[-0.125:0.0001:0.125];
T2=[-0.0625:0.0001:0.0625];
y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T1)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T1))/500;
y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T2)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T2))/500;
Y1=(real(RFFT(4))*cos(2*pi*FreqAxis(4)*T)-imag(RFFT(4))*sin(2*pi*FreqAxis(4)*T))/500;
Y2=(real(RFFT(8))*cos(2*pi*FreqAxis(8)*T)-imag(RFFT(8))*sin(2*pi*FreqAxis(8)*T))/500;
[Max1,MaxPhaseI1]=max(y1);
[Max2,MaxPhaseI2]=max(y2);
plot((T1(MaxPhaseI1))/0.125,Max1,'ro',(T2(MaxPhaseI2))/0.0625,Max2,'go'),grid;
axis([-1 1 0 4]);
set(gca,'xtick',[-1 0 1]);
MaxPhaseAmp4Hz8Hz=[T1(MaxPhaseI1) T2(MaxPhaseI2);Max1 Max2]

