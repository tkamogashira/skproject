% V to FFTPowerPhasePlot12468v2
function VtoFFTPowerPhasePlot12468v2(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
Phase=unwrap(angle(FFT(1:length(FFT)/2)))/pi
semilogy(Phase(1),Power(1),'r+',(Phase(1)-2),Power(1),'r+',(Phase(1)+2),Power(1),'r+',...
    Phase(2),Power(2),'rx',(Phase(2)-2),Power(2),'rx',(Phase(2)+2),Power(2),'rx',...
    Phase(4),Power(4),'rv',(Phase(4)-2),Power(4),'rv',(Phase(4)+2),Power(4),'rv',...
    Phase(6),Power(6),'rd',(Phase(6)-4),Power(6),'rd',(Phase(6)-2),Power(6),'rd',...
    Phase(8),Power(8),'rp',(Phase(8)-4),Power(8),'rp',(Phase(8)-2),Power(8),'rp'),grid
axis([-1 1 0 100000])

