% V to FFTPowerPhasePlot12345
function VtoFFTPowerPhasePlot12345(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
Phase=unwrap(angle(FFT(1:length(FFT)/2)))/pi
semilogy(Phase(1),Power(1),'r+',(Phase(1)-2),Power(1),'r+',(Phase(1)+2),Power(1),'r+',...
    Phase(2),Power(2),'rx',(Phase(2)-2),Power(2),'rx',(Phase(2)+2),Power(2),'rx',...
    Phase(3),Power(3),'ro',(Phase(3)-2),Power(3),'ro',(Phase(3)+2),Power(3),'ro',...
    Phase(4),Power(4),'rv',(Phase(4)-2),Power(4),'rv',(Phase(4)+2),Power(4),'rv',...
    Phase(5),Power(5),'rs',(Phase(5)-2),Power(5),'rs',(Phase(5)+2),Power(5),'rs'),grid
axis([-1 1 0 100000])

