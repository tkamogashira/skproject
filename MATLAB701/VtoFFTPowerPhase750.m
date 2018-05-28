% V to FFTPowerPhase750
function VtoFFTPowerPhase750(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
Phase=unwrap(angle(FFT(1:length(FFT)/2)))/pi
FFTPowerPhase=[FreqAxis(1:12);Power(1:12);Phase(1:12)]
